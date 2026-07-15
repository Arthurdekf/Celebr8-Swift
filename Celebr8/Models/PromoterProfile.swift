//
//  PromoterProfile.swift
//  Celebr8
//
//  Created by Arthur Fedeli on 11/07/26.
//

import Foundation

struct PromoterProfile: Identifiable, Codable, Sendable {
    var id: String {
        userId
    }

    let userId: String
    var plan: PromoterPlan
    var isVerified: Bool
    var followerCount: Int
    var averageRating: Double
    var ratingCount: Int
    let createdAt: Date
    var updatedAt: Date
}
