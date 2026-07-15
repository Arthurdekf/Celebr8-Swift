//
//  RegistrationViewModel.swift
//  Celebr8
//
//  Created by Arthur Fedeli on 11/07/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class RegistrationViewModel {
    static let minimumCategoryCount = 2
    static let maximumCategoryCount = 6
    static let maximumBioLength = 160
    static let minimumPasswordLength =
        AuthenticationInputValidator.minimumPasswordLength
    
    var displayName = ""
    var username = ""
    var email = ""
    var password = ""
    var passwordConfirmation = ""
    let accountType: AccountType
    let promoterPlan: PromoterPlan?
    
    var bio = ""
    var gender: UserGender?
    var birthDate: Date?
    var selectedCategoryIDs: Set<String> = []
    
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    
    private let authenticationService: AuthenticationService
    private let userService: UserService
    
    init(
        accountType: AccountType,
        promoterPlan: PromoterPlan?,
        authenticationService: AuthenticationService,
        userService: UserService
    ) {
        precondition(
            accountType.isPromoter == (promoterPlan != nil),
            "Divulgadores devem possuir um plano e participantes não."
        )
        
        self.accountType = accountType
        self.promoterPlan = promoterPlan
        self.authenticationService = authenticationService
        self.userService = userService
    }
    
    convenience init(
        accountType: AccountType,
        promoterPlan: PromoterPlan? = nil
    ) {
        self.init(
            accountType: accountType,
            promoterPlan: promoterPlan,
            authenticationService: AuthenticationService(),
            userService: UserService()
        )
    }
    
    private var normalizedEmail: String {
        email
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
    }
    
    private var normalizedUsername: String {
        username
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
    }
    
    private var trimmedDisplayName: String {
        displayName.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private var trimmedBio: String {
        bio.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func toggleCategory(id categoryID: String) {
        if selectedCategoryIDs.contains(categoryID) {
            selectedCategoryIDs.remove(categoryID)
            return
        }
        
        guard selectedCategoryIDs.count <
                Self.maximumCategoryCount else {
            return
        }
        
        selectedCategoryIDs.insert(categoryID)
    }
    
    func isCategorySelected(
        id categoryID: String
    ) -> Bool {
        selectedCategoryIDs.contains(categoryID)
    }
    
    func register() async -> AppUser? {
        guard !isLoading else {
            return nil
        }
        
        errorMessage = nil
        
        guard validateAccessFields(),
              validateProfileFields(),
              validateCategories() else {
            return nil
        }
        
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            let userID = try await authenticationService.createAccount(
                email: normalizedEmail,
                password: password
            )
            
            let user = makeUser(id: userID)
            
            let promoterProfile = makePromoterProfile(
                for: user
            )
            
            do {
                try await userService.createUser(
                    user,
                    promoterProfile: promoterProfile
                )
            } catch {
                try? await authenticationService.deleteCurrentAccount()
                throw error
            }
            
            password = ""
            passwordConfirmation = ""
            
            return user
        } catch {
            errorMessage = error.localizedDescription
            return nil
        }
    }
    
    func validateAccess() -> Bool {
        errorMessage = nil
        return validateAccessFields()
    }
    
    func validateProfile() -> Bool {
        errorMessage = nil
        return validateProfileFields()
    }
    
    private func validateAccessFields() -> Bool {
        guard AuthenticationInputValidator.isValidEmail(
            normalizedEmail
        ) else {
            errorMessage = "Informe um endereço de e-mail válido."
            return false
        }
        
        guard AuthenticationInputValidator.isValidNewPassword(
            password
        ) else {
            errorMessage =
                "A senha deve ter pelo menos \(Self.minimumPasswordLength) caracteres e conter ao menos um número."
            return false
        }
        
        guard password == passwordConfirmation else {
            errorMessage = "As senhas não coincidem."
            return false
        }
        
        return true
    }
    
    private func validateProfileFields() -> Bool {
        guard (2...80).contains(trimmedDisplayName.count) else {
            errorMessage = "O nome deve ter entre 2 e 80 caracteres."
            return false
        }
        
        guard isValidUsername(normalizedUsername) else {
            errorMessage =
            "O nome de usuário deve ter entre 3 e 30 caracteres e usar apenas letras, números, ponto ou underline."
            
            return false
        }
        
        guard trimmedBio.count <= Self.maximumBioLength else {
            errorMessage =
            "A bio deve ter no máximo \(Self.maximumBioLength) caracteres."
            
            return false
        }
        
        guard gender != nil else {
            errorMessage = "Selecione seu gênero."
            return false
        }
        
        guard let birthDate else {
            errorMessage = "Informe sua data de nascimento."
            return false
        }
        
        guard birthDate <= Date() else {
            errorMessage =
            "A data de nascimento não pode estar no futuro."
            
            return false
        }
        
        return true
    }
    
    private func validateCategories() -> Bool {
        guard (
            Self.minimumCategoryCount...Self.maximumCategoryCount
        ).contains(selectedCategoryIDs.count) else {
            errorMessage =
            "Selecione entre \(Self.minimumCategoryCount) e \(Self.maximumCategoryCount) categorias favoritas."
            return false
        }
        
        return true
    }
    
    private func makeUser(id: String) -> AppUser {
        let now = Date()
        
        let categoryIDs = selectedCategoryIDs.sorted()
        
        return AppUser(
            id: id,
            username: normalizedUsername,
            displayName: trimmedDisplayName,
            bio: trimmedBio.isEmpty ? nil : trimmedBio,
            photoURL: nil,
            gender: gender,
            birthDate: birthDate,
            favoriteCategoryIDs: categoryIDs,
            accountType: accountType,
            createdAt: now,
            updatedAt: now
        )
    }
    
    private func makePromoterProfile(
        for user: AppUser
    ) -> PromoterProfile? {
        guard user.accountType.isPromoter,
              let promoterPlan else {
            return nil
        }
        
        return PromoterProfile(
            userId: user.id,
            plan: promoterPlan,
            isVerified: false,
            followerCount: 0,
            averageRating: 0,
            ratingCount: 0,
            createdAt: user.createdAt,
            updatedAt: user.updatedAt
        )
    }
    
    private func isValidUsername(_ username: String) -> Bool {
        username.range(
            of: #"^[a-z0-9._]{3,30}$"#,
            options: .regularExpression
        ) != nil
    }
}
