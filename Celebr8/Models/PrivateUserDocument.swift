//
//  PrivateUserDocument.swift
//  Celebr8
//
//  Created by Arthur Fedeli on 15/07/26.
//

import Foundation

struct PrivateUserDocument: Codable, Sendable {
    let userId: String
    let gender: UserGender?
    let birthDate: Date?
    let favoriteCategoryIDs: [String]
    let createdAt: Date
    let updatedAt: Date

    init(user: AppUser) {
        userId = user.id
        gender = user.gender
        birthDate = user.birthDate
        favoriteCategoryIDs = user.favoriteCategoryIDs
        createdAt = user.createdAt
        updatedAt = user.updatedAt
    }
}
