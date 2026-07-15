//
//  UserService.swift
//  Celebr8
//
//  Created by Arthur Fedeli on 11/07/26.
//

import Foundation
import FirebaseFirestore

enum UserServiceError: LocalizedError {
    case usernameUnavailable
    case incompleteProfile
    case invalidPromoterProfile
    
    var errorDescription: String? {
        switch self {
        case .usernameUnavailable:
            return "Este nome de usuário já está em uso."
            
        case .incompleteProfile:
            return "Os dados deste perfil estão incompletos."
            
        case .invalidPromoterProfile:
            return "A configuração do perfil de divulgador é inválida."
        }
    }
}

final class UserService {
    private let database: Firestore
    
    init(database: Firestore = Firestore.firestore()) {
        self.database = database
    }
    
    func createUser(
        _ user: AppUser,
        promoterProfile: PromoterProfile?
    ) async throws {
        
        guard hasValidPromoterConfiguration(
            user: user,
            promoterProfile: promoterProfile
        ) else {
            throw UserServiceError.invalidPromoterProfile
        }
        
        let publicUserData = try Firestore.Encoder().encode(
            PublicUserDocument(user: user)
        )
        
        let privateUserData = try Firestore.Encoder().encode(
            PrivateUserDocument(user: user)
        )
        
        let promoterProfileData = try promoterProfile.map {
            try Firestore.Encoder().encode($0)
        }
        
        let publicUserReference = database
            .collection("users")
            .document(user.id)
        
        let privateUserReference = database
            .collection("userPrivateProfiles")
            .document(user.id)
        
        let usernameReference = database
            .collection("usernames")
            .document(user.username)
        
        let promoterProfileReference = database
            .collection("promoterProfiles")
            .document(user.id)
        
        _ = try await database.runTransaction {
            transaction,
            errorPointer in
            
            do {
                let usernameSnapshot = try transaction.getDocument(
                    usernameReference
                )
                
                guard !usernameSnapshot.exists else {
                    errorPointer?.pointee =
                    UserServiceError.usernameUnavailable as NSError
                    
                    return nil
                }
                
                transaction.setData(
                    ["userId": user.id],
                    forDocument: usernameReference
                )
                
                transaction.setData(
                    publicUserData,
                    forDocument: publicUserReference
                )
                
                transaction.setData(
                    privateUserData,
                    forDocument: privateUserReference
                )
                
                if let promoterProfileData {
                    transaction.setData(
                        promoterProfileData,
                        forDocument: promoterProfileReference
                    )
                }
                
                return nil
            } catch {
                errorPointer?.pointee = error as NSError
                return nil
            }
        }
    }
    
    func fetchUser(id: String) async throws -> AppUser? {
        async let publicUserResult = database
            .collection("users")
            .document(id)
            .getDocument(as: PublicUserDocument?.self)
        
        async let privateUserResult = database
            .collection("userPrivateProfiles")
            .document(id)
            .getDocument(as: PrivateUserDocument?.self)
        
        let (publicUser, privateUser) = try await (
            publicUserResult,
            privateUserResult
        )
        
        guard let publicUser else {
            return nil
        }
        
        guard let privateUser,
              privateUser.userId == publicUser.id else {
            throw UserServiceError.incompleteProfile
        }
        
        return AppUser(
            id: publicUser.id,
            username: publicUser.username,
            displayName: publicUser.displayName,
            bio: publicUser.bio,
            photoURL: publicUser.photoURL,
            gender: privateUser.gender,
            birthDate: privateUser.birthDate,
            favoriteCategoryIDs:
                privateUser.favoriteCategoryIDs,
            accountType: publicUser.accountType,
            createdAt: publicUser.createdAt,
            updatedAt: max(
                publicUser.updatedAt,
                privateUser.updatedAt
            )
        )
    }
    private func hasValidPromoterConfiguration(
        user: AppUser,
        promoterProfile: PromoterProfile?
    ) -> Bool {
        if user.accountType.isPromoter {
            return promoterProfile?.userId == user.id
        }
        
        return promoterProfile == nil
    }
}
