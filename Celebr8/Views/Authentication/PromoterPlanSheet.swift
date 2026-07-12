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
                VStack(spacing: AppSpacing.extraLarge) {
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
                            "A conta de divulgador é destinada a pessoas ou organizações que promovem eventos. Escolha esta opção somente se estiver divulgando algo real e de forma responsável."
                        )
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
                .padding(.top, AppSpacing.medium)
                .padding(.bottom, AppSpacing.section)
            }
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: AppSpacing.compact) {
                    Button {
                        onSelectPlan(.pro)
                    } label: {
                        VStack(
                            spacing: AppSpacing.extraSmall
                        ) {
                            Text("Continuar com o Pro")
                                .fontWeight(.semibold)

                            Text(
                                SubscriptionConfiguration
                                    .sampleMonthlyPrice
                            )
                            .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)

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
                .padding(.bottom, AppSpacing.small)
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
            spacing: AppSpacing.medium
        ) {
            HStack {
                Text(title)
                    .font(.headline)

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
                HStack(spacing: AppSpacing.compact) {
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
