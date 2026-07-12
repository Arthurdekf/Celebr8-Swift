//
//  PromoterPlan.swift
//  Celebr8
//
//  Created by Arthur Fedeli on 11/07/26.
//

enum PromoterPlan: String, Codable, Sendable {
    case free
    case pro

    var isPro: Bool {
        self == .pro
    }
}
