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
    var displayName = ""
    var username = ""
    var email = ""
    var password = ""
    var passwordConfirmation = ""

    private(set) var isLoading = false
    private(set) var errorMessage: String?

    private let authenticationService: AuthenticationService
    private let userService: UserService

    init(
        authenticationService: AuthenticationService,
        userService: UserService
    ) {
        self.authenticationService = authenticationService
        self.userService = userService
    }

    convenience init() {
        self.init(
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

    func register() async -> AppUser? {
        guard !isLoading else {
            return nil
        }

        errorMessage = nil

        guard validateForm() else {
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

            do {
                try await userService.createUser(user)
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

    private func validateForm() -> Bool {
        guard (2...80).contains(trimmedDisplayName.count) else {
            errorMessage = "O nome deve ter entre 2 e 80 caracteres."
            return false
        }

        guard isValidUsername(normalizedUsername) else {
            errorMessage =
                "O nome de usuário deve ter entre 3 e 30 caracteres e usar apenas letras, números, ponto ou underline."
            return false
        }

        guard !normalizedEmail.isEmpty else {
            errorMessage = "Informe seu e-mail."
            return false
        }

        guard password.count >= 8 else {
            errorMessage = "A senha deve ter pelo menos 8 caracteres."
            return false
        }

        guard password == passwordConfirmation else {
            errorMessage = "As senhas não coincidem."
            return false
        }

        return true
    }

    private func makeUser(id: String) -> AppUser {
        let now = Date()

        return AppUser(
            id: id,
            username: normalizedUsername,
            displayName: trimmedDisplayName,
            bio: nil,
            photoURL: nil,
            accountType: .attendee,
            createdAt: now,
            updatedAt: now
        )
    }

    private func isValidUsername(_ username: String) -> Bool {
        username.range(
            of: #"^[a-z0-9._]{3,30}$"#,
            options: .regularExpression
        ) != nil
    }
}
