//
//  BrandLogo.swift
//  Celebr8
//
//  Created by Arthur Fedeli on 10/07/26.
//

import SwiftUI

struct BrandLogo: View {
    var size: CGFloat = 40

    private var logoFont: Font {
        .custom(
            "Galada-Regular",
            size: size,
            relativeTo: .largeTitle
        )
    }

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 9) {
            Text("Celebr")
                .font(logoFont)

            Text("8")
                .font(logoFont)
                .fontWeight(.heavy)
                .rotationEffect(
                    .degrees(-14),
                    anchor: .bottomLeading
                )
        }
        .foregroundStyle(.primary)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Celebr8")
    }
}

#Preview {
    BrandLogo()
        .padding()
}
