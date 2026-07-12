//
//  AccountType.swift
//  Celebr8
//
//  Created by Arthur Fedeli on 11/07/26.
//

enum AccountType: String, Codable, Hashable, Sendable {
    case attendee
    case promoter

    var isPromoter: Bool {
        self == .promoter
    }
}
