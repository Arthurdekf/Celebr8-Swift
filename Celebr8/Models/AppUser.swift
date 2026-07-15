//
//  AppUser.swift
//  Celebr8
//
//  Created by Arthur Fedeli on 11/07/26.
//

import Foundation

struct AppUser: Identifiable, Sendable {
    let id: String
    let username: String
    var displayName: String
    var bio: String?
    var photoURL: URL?
    var gender: UserGender?
    var birthDate: Date?
    var favoriteCategoryIDs: [String]
    let accountType: AccountType
    let createdAt: Date
    var updatedAt: Date
}
