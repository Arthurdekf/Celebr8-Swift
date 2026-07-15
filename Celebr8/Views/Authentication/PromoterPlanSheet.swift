//
//  PromoterPlanSheet.swift
//  Celebr8
//
//  Created by Arthur Fedeli on 11/07/26.
//

import SwiftUI

@MainActor
struct PromoterPlanSheet: View {
    private let onSelectPlan: (PromoterPlan) -> Void
    
    init(
        onSelectPlan: @escaping (PromoterPlan) -> Void
    ) {
        self.onSelectPlan = onSelectPlan
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.medium) {
                Image(
                    systemName: "exclamationmark.triangle.fill"
                )
                .font(.largeTitle)
                .foregroundStyle(AppColors.warning)
                
                VStack(spacing: AppSpacing.small) {
                    Text("Atenção")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(
                        "A conta de divulgador é destinada a pessoas ou organizações que promovem eventos. Escolha esta opção somente se estiver divulgando algo genuíno"
                    )
                    .font(.subheadline)
                    .foregroundStyle(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                }
                
                PlanCard(
                    title: "Conta gratuita",
                    price: "Grátis",
                    features: [
                        PlanFeature(
                            title: "1 evento ativo por vez",
                            emoji: "🔒"
                        ),
                        PlanFeature(
                            title:
                                "1 publicação promocional por dia",
                            emoji: "🔒"
                        ),
                        PlanFeature(
                            title: "Dashboard básico",
                            emoji: "📈"
                        ),
                        PlanFeature(
                            title: "Suporte padrão",
                            emoji: "✉️"
                        ),
                        PlanFeature(
                            title:
                                "Publicação manual, sem agendamento",
                            emoji: "❌"
                        )
                    ],
                    isHighlighted: false
                )
                
                PlanCard(
                    title: "Celebr8 Pro",
                    price:
                        SubscriptionConfiguration
                        .sampleMonthlyPrice,
                    features: [
                        PlanFeature(
                            title:
                                "Eventos sem limite do plano",
                            emoji: "🗓️"
                        ),
                        PlanFeature(
                            title:
                                "Publicações promocionais sem limite",
                            emoji: "📣"
                        ),
                        PlanFeature(
                            title: "Dashboard avançado",
                            emoji: "📊"
                        ),
                        PlanFeature(
                            title: "Suporte prioritário",
                            emoji: "🛟"
                        ),
                        PlanFeature(
                            title:
                                "Agendamento de eventos e publicações",
                            emoji: "⏰"
                        )
                    ],
                    isHighlighted: true
                )
                
                Text(
                    "Valor ilustrativo. A assinatura ainda não será cobrada nesta versão."
                )
                .font(.caption)
                .foregroundStyle(AppColors.secondaryText)
                .multilineTextAlignment(.center)
            }
            .padding(.horizontal, AppSpacing.extraLarge)
            .padding(.top, AppSpacing.spacious)
            .padding(.bottom, AppSpacing.large)
        }
        .scrollBounceBehavior(.basedOnSize)
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: AppSpacing.compact) {
                Button {
                    onSelectPlan(.pro)
                } label: {
                    VStack(spacing: AppSpacing.extraSmall) {
                        Label(
                            "Continuar com o Pro",
                            systemImage: "party.popper"
                        )
                        .fontWeight(.bold)
                        
                        Text(
                            SubscriptionConfiguration
                                .sampleMonthlyPrice
                        )
                        .font(.caption)
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 60)
                    .background {
                        LinearGradient(
                            colors: [
                                AppColors.brand,
                                Color(uiColor: .systemIndigo)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    }
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: AppRadius.extraLarge,
                            style: .continuous
                        )
                    )
                    .shadow(
                        color: AppColors.brand.opacity(0.25),
                        radius: 8,
                        y: 4
                    )
                }
                .buttonStyle(.plain)
                
                Button("Continuar gratuitamente") {
                    onSelectPlan(.free)
                }
                .fontWeight(.semibold)
            }
            .padding(
                .horizontal,
                AppSpacing.extraLarge
            )
            .padding(.top, AppSpacing.compact)
            .padding(.bottom, AppSpacing.extraSmall)
            .background(.ultraThinMaterial)
        }
        .presentationDragIndicator(.visible)
    }
}


private struct PlanFeature {
    let title: String
    let emoji: String
}

private struct PlanCard: View {
    let title: String
    let price: String
    let features: [PlanFeature]
    let isHighlighted: Bool
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.compact
        ) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(
                        isHighlighted
                        ? AppColors.brand
                        : AppColors.primaryText
                    )
                
                Spacer()
                
                Text(price)
                    .font(.headline)
                    .foregroundStyle(
                        isHighlighted
                        ? AppColors.brand
                        : AppColors.primaryText
                    )
            }
            
            ForEach(features, id: \.title) { feature in
                HStack(spacing: AppSpacing.small) {
                    Text(feature.emoji)
                        .font(.title3)
                        .frame(width: AppSpacing.extraLarge)
                        .accessibilityHidden(true)
                    
                    Text(feature.title)
                        .font(.subheadline)
                }
            }
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding(AppSpacing.medium)
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
                isHighlighted
                ? AppColors.brand
                : AppColors.separator,
                lineWidth: isHighlighted ? 2 : 1
            )
        }
    }
}

#Preview {
    PromoterPlanSheet(
        onSelectPlan: { _ in }
    )
}
