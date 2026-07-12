//
//  LoginViewModel.swift
//  Celebr8
//
//  Created by Arthur Fedeli on 11/07/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class LoginViewModel {
    var email = ""
    var password = ""

    private(set) var isLoading = false
    private(set) var errorMessage: String?
    private(set) var confirmationMessage: String?

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

    var canRevealPassword: Bool {
        !normalizedEmail.isEmpty
    }

    func signIn() async -> AppUser? {
        guard !isLoading else {
            return nil
        }

        errorMessage = nil
        confirmationMessage = nil

        guard validateCredentials() else {
            return nil
        }

        isLoading = true

        defer {
            isLoading = false
        }

        do {
            let userID = try await authenticationService.signIn(
                email: normalizedEmail,
                password: password
            )

            do {
                guard let user = try await userService.fetchUser(
                    id: userID
                ) else {
                    try? authenticationService.signOut()

                    errorMessage =
                        "Não foi possível encontrar o perfil desta conta."

                    return nil
                }

                password = ""
                return user
            } catch {
                try? authenticationService.signOut()
                throw error
            }
        } catch {
            errorMessage = error.localizedDescription
            return nil
        }
    }

    func sendPasswordReset() async {
        guard !isLoading else {
            return
        }

        errorMessage = nil
        confirmationMessage = nil

        guard !normalizedEmail.isEmpty else {
            errorMessage =
                "Informe seu e-mail para recuperar a senha."
            return
        }

        isLoading = true

        defer {
            isLoading = false
        }

        do {
            try await authenticationService.sendPasswordReset(
                to: normalizedEmail
            )

            confirmationMessage =
                "Enviamos as instruções de recuperação para seu e-mail."
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func validateCredentials() -> Bool {
        guard !normalizedEmail.isEmpty else {
            errorMessage = "Informe seu e-mail."
            return false
        }

        guard !password.isEmpty else {
            errorMessage = "Informe sua senha."
            return false
        }

        return true
    }
}
