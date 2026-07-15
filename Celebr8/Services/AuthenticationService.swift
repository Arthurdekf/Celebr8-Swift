//
//  AuthenticationService.swift
//  Celebr8
//
//  Created by Arthur Fedeli on 11/07/26.
//

import FirebaseAuth

final class AuthenticationService {
    private let auth: Auth
    
    init(auth: Auth = Auth.auth()) {
        self.auth = auth
    }
    
    var currentUserID: String? {
        auth.currentUser?.uid
    }
    
    func createAccount(
        email: String,
        password: String
    ) async throws -> String {
        let result = try await auth.createUser(
            withEmail: email,
            password: password
        )
        
        return result.user.uid
    }
    
    func signIn(
        email: String,
        password: String
    ) async throws -> String {
        let result = try await auth.signIn(
            withEmail: email,
            password: password
        )
        
        return result.user.uid
    }
    
    func sendPasswordReset(to email: String) async throws {
        try await auth.sendPasswordReset(withEmail: email)
    }
    
    func signOut() throws {
        try auth.signOut()
    }
    
    func deleteCurrentAccount() async throws {
        guard let user = auth.currentUser else {
            return
        }
        
        try await user.delete()
    }
}
