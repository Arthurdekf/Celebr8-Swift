//
//  PublicUserDocument.swift
//  Celebr8
//
//  Created by Arthur Fedeli on 15/07/26.
//

import Foundation

struct PublicUserDocument: Codable, Sendable {
    let id: String
    let username: String
    let displayName: String
    let bio: String?
    let photoURL: URL?
    let accountType: AccountType
    let createdAt: Date
    let updatedAt: Date

    init(user: AppUser) {
        id = user.id
        username = user.username
        displayName = user.displayName
        bio = user.bio
        photoURL = user.photoURL
        accountType = user.accountType
        createdAt = user.createdAt
        updatedAt = user.updatedAt
    }
}
