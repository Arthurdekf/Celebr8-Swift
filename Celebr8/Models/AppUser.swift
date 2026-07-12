//
//  AppUser.swift
//  Celebr8
//
//  Created by Arthur Fedeli on 11/07/26.
//

import Foundation

struct AppUser: Identifiable, Codable, Sendable {
    let id: String
    var username: String
    var displayName: String
    var bio: String?
    var photoURL: URL?
    var accountType: AccountType
    let createdAt: Date
    var updatedAt: Date
}
