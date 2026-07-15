//
//  AuthenticationFlowView.swift
//  Celebr8
//
//  Created by Arthur Fedeli on 11/07/26.
//

import SwiftUI

@MainActor
struct AuthenticationFlowView: View {
    @State private var path: [Destination] = []
    @State private var showsPromoterPlan = false
    @State private var pendingDestination: Destination?
    
    private let onAuthenticationCompleted: (AppUser) -> Void
    
    init(
        onAuthenticationCompleted: @escaping (AppUser) -> Void
    ) {
        self.onAuthenticationCompleted = onAuthenticationCompleted
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            LoginView(
                onSignInCompleted: onAuthenticationCompleted,
                onCreateAccount: {
                    path.append(.accountTypeSelection)
                }
            )
            .navigationDestination(for: Destination.self) {
                destination in
                destinationView(for: destination)
            }
        }
        .sheet(
            isPresented: $showsPromoterPlan,
            onDismiss: continueAfterPlanSelection
        ) {
            PromoterPlanSheet { plan in
                pendingDestination = .registration(
                    accountType: .promoter,
                    promoterPlan: plan
                )
                
                showsPromoterPlan = false
            }
        }
    }
    
    @ViewBuilder
    private func destinationView(
        for destination: Destination
    ) -> some View {
        switch destination {
        case .accountTypeSelection:
            AccountTypeSelectionView { accountType in
                continueWith(accountType)
            }
            
        case let .registration(
            accountType,
            promoterPlan
        ):
            RegistrationView(
                accountType: accountType,
                promoterPlan: promoterPlan,
                onRegistrationCompleted:
                    onAuthenticationCompleted
            )
        }
    }
    
    private func continueWith(
        _ accountType: AccountType
    ) {
        if accountType.isPromoter {
            showsPromoterPlan = true
        } else {
            path.append(
                .registration(
                    accountType: .attendee,
                    promoterPlan: nil
                )
            )
        }
    }
    
    private func continueAfterPlanSelection() {
        guard let pendingDestination else {
            return
        }
        
        self.pendingDestination = nil
        path.append(pendingDestination)
    }
}

private enum Destination: Hashable {
    case accountTypeSelection
    
    case registration(
        accountType: AccountType,
        promoterPlan: PromoterPlan?
    )
}

#Preview {
    AuthenticationFlowView(
        onAuthenticationCompleted: { _ in }
    )
}
