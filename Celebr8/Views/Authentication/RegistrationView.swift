//
//  RegistrationView.swift
//  Celebr8
//
//  Created by Arthur Fedeli on 11/07/26.
//

import SwiftUI

@MainActor
struct RegistrationView: View {
    @State private var viewModel: RegistrationViewModel
    @State private var showsProfile = false

    private let onRegistrationCompleted: (AppUser) -> Void

    init(
        accountType: AccountType,
        promoterPlan: PromoterPlan? = nil,
        onRegistrationCompleted: @escaping (AppUser) -> Void = { _ in }
    ) {
        _viewModel = State(
            initialValue: RegistrationViewModel(
                accountType: accountType,
                promoterPlan: promoterPlan
            )
        )

        self.onRegistrationCompleted = onRegistrationCompleted
    }

    var body: some View {
        RegistrationAccessView(
            viewModel: viewModel,
            onContinue: {
                showsProfile = true
            }
        )
        .navigationDestination(
            isPresented: $showsProfile
        ) {
            RegistrationProfileView(
                viewModel: viewModel,
                onRegistrationCompleted:
                    onRegistrationCompleted
            )
        }
    }
}

#Preview("Participante") {
    NavigationStack {
        RegistrationView(
            accountType: .attendee
        )
    }
}

#Preview("Divulgador") {
    NavigationStack {
        RegistrationView(
            accountType: .promoter,
            promoterPlan: .free
        )
    }
}
