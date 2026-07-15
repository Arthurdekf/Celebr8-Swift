//
//  RegistrationFieldContainer.swift
//  Celebr8
//
//  Created by Arthur Fedeli on 15/07/26.
//

import SwiftUI

struct RegistrationFieldContainer<Content: View>: View {
    private let content: Content

    init(
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(.horizontal, AppSpacing.medium)
            .padding(.vertical, AppSpacing.compact)
            .background(
                AppColors.secondaryBackground,
                in: RoundedRectangle(
                    cornerRadius: AppRadius.medium,
                    style: .continuous
                )
            )
    }
}
