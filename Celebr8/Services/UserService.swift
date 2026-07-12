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

    var errorDescription: String? {
        switch self {
        case .usernameUnavailable:
            return "Este nome de usuário já está em uso."
        }
    }
}

final class UserService {
    private let database: Firestore

    init(database: Firestore = Firestore.firestore()) {
        self.database = database
    }

    func createUser(_ user: AppUser) async throws {
        let userData = try Firestore.Encoder().encode(user)

        let userDocument = database
            .collection("users")
            .document(user.id)

        let usernameDocument = database
            .collection("usernames")
            .document(user.username)

        _ = try await database.runTransaction {
            transaction,
            errorPointer in

            do {
                let usernameSnapshot = try transaction.getDocument(
                    usernameDocument
                )

                guard !usernameSnapshot.exists else {
                    errorPointer?.pointee =
                        UserServiceError.usernameUnavailable as NSError
                    return nil
                }

                transaction.setData(
                    ["userId": user.id],
                    forDocument: usernameDocument
                )

                transaction.setData(
                    userData,
                    forDocument: userDocument
                )

                return nil
            } catch {
                errorPointer?.pointee = error as NSError
                return nil
            }
        }
    }

    func fetchUser(id: String) async throws -> AppUser? {
        try await database
            .collection("users")
            .document(id)
            .getDocument(as: AppUser?.self)
    }
}
