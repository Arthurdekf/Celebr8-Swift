//
//  AuthenticationInputValidator.swift
//  Celebr8
//
//  Created by Arthur Fedeli on 15/07/26.
//

import Foundation

enum AuthenticationInputValidator {
    static let minimumPasswordLength = 12

    private static let emailPattern =
        #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#

    static func isValidEmail(_ email: String) -> Bool {
        email.range(
            of: emailPattern,
            options: .regularExpression
        ) != nil
    }

    static func isValidNewPassword(_ password: String) -> Bool {
        password.count >= minimumPasswordLength
            && password.rangeOfCharacter(from: .decimalDigits) != nil
    }
}
