//
//  AccountTypeSelectionView.swift
//  Celebr8
//
//  Created by Arthur Fedeli on 11/07/26.
//

import SwiftUI

@MainActor
struct AccountTypeSelectionView: View {
    @State private var selectedAccountType: AccountType?
    
    private let onContinue: (AccountType) -> Void
    
    init(
        onContinue: @escaping (AccountType) -> Void
    ) {
        self.onContinue = onContinue
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.extraLarge) {
                BrandLogo(size: 44)
                
                VStack(spacing: AppSpacing.small) {
                    Text("Como você quer usar o Celebr8?")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                    
                    Text(
                        "Escolha o tipo de perfil que melhor representa você."
                    )
                    .foregroundStyle(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                }
                
                VStack(spacing: AppSpacing.medium) {
                    AccountTypeCard(
                        title: "Participante",
                        description:
                            "Descubra, participe e avalie eventos.",
                        emoji: "🎉",
                        isSelected:
                            selectedAccountType == .attendee
                    ) {
                        withAnimation(.snappy) {
                            selectedAccountType = .attendee
                        }
                    }
                    
                    AccountTypeCard(
                        title: "Divulgador",
                        description:
                            "Crie eventos e conecte-se com seu público.",
                        emoji: "📣",
                        isSelected:
                            selectedAccountType == .promoter
                    ) {
                        withAnimation(.snappy) {
                            selectedAccountType = .promoter
                        }
                    }
                }
                
                if selectedAccountType == .promoter {
                    Label(
                        "O perfil de divulgador é destinado a pessoas ou organizações que promovem eventos.",
                        systemImage: "info.circle"
                    )
                    .font(.footnote)
                    .foregroundStyle(AppColors.secondaryText)
                    .transition(.opacity)
                }
                
                Button {
                    guard let selectedAccountType else {
                        return
                    }
                    
                    onContinue(selectedAccountType)
                } label: {
                    Text("Continuar")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(selectedAccountType == nil)
            }
            .padding(.horizontal, AppSpacing.extraLarge)
            .padding(.vertical, AppSpacing.section)
        }
        .scrollBounceBehavior(.basedOnSize)
        .navigationTitle("Tipo de perfil")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct AccountTypeCard: View {
    let title: String
    let description: String
    let emoji: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.medium) {
                Text(emoji)
                    .font(.largeTitle)
                    .frame(
                        width: AppSpacing.extraSpacious,
                        height: AppSpacing.extraSpacious
                    )
                    .accessibilityHidden(true)
                
                VStack(
                    alignment: .leading,
                    spacing: AppSpacing.extraSmall
                ) {
                    Text(title)
                        .font(.headline)
                    
                    Text(description)
                        .font(.subheadline)
                        .foregroundStyle(
                            AppColors.secondaryText
                        )
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(
                    systemName: isSelected
                    ? "checkmark.circle.fill"
                    : "circle"
                )
                .font(.title3)
            }
            .padding(AppSpacing.medium)
            .contentShape(Rectangle())
            .background(
                AppColors.secondaryBackground,
                in: RoundedRectangle(
                    cornerRadius: AppRadius.medium,
                    style: .continuous
                )
            )
            .overlay {
                RoundedRectangle(
                    cornerRadius: AppRadius.medium,
                    style: .continuous
                )
                .stroke(
                    isSelected
                    ? AppColors.brand
                    : AppColors.separator,
                    lineWidth: isSelected ? 2 : 1
                )
            }
        }
        .buttonStyle(.plain)
        .foregroundStyle(
            isSelected
            ? AppColors.brand
            : AppColors.primaryText
        )
        .accessibilityAddTraits(
            isSelected ? .isSelected : []
        )
    }
}

#Preview {
    NavigationStack {
        AccountTypeSelectionView { _ in }
    }
}
