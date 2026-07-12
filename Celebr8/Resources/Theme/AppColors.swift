//
//  AppColors.swift
//  Celebr8
//
//  Created by Arthur Fedeli on 10/07/26.
//

import SwiftUI

enum AppColors {
    // Marca
    static let brand = Color.accentColor

    // Textos
    static let primaryText = Color.primary
    static let secondaryText = Color.secondary
    static let tertiaryText = Color(uiColor: .tertiaryLabel)

    // Fundos
    static let background = Color(uiColor: .systemBackground)
    static let secondaryBackground = Color(uiColor: .secondarySystemBackground)
    static let tertiaryBackground = Color(uiColor: .tertiarySystemBackground)

    // Interface
    static let separator = Color(uiColor: .separator)
    static let error = Color(uiColor: .systemRed)
    static let warning = Color(uiColor: .systemOrange)
}
