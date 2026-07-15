//
//  RegistrationAccessView.swift
//  Celebr8
//
//  Created by Arthur Fedeli on 15/07/26.
//

import SwiftUI

@MainActor
struct RegistrationAccessView: View {
    @Bindable var viewModel: RegistrationViewModel

    let onContinue: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.section) {
                header
                accessFields
                errorSection
            }
            .padding(.horizontal, AppSpacing.extraLarge)
            .padding(.top, AppSpacing.small)
            .padding(.bottom, AppSpacing.medium)
        }
        .scrollDismissesKeyboard(.interactively)
        .safeAreaInset(edge: .bottom) {
            continueButton
        }
        .navigationTitle("Criar sua conta")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(spacing: AppSpacing.small) {
            BrandLogo(size: 34)

            Text(accountTypeTitle)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(AppColors.brand)

            Text("Crie seus dados de acesso")
                .font(.title2)
                .fontWeight(.semibold)

            Text(
                "Informe seu e-mail e escolha uma senha segura."
            )
            .foregroundStyle(AppColors.secondaryText)
            .multilineTextAlignment(.center)
        }
    }

    private var accessFields: some View {
        VStack(spacing: AppSpacing.medium) {
            RegistrationFieldContainer {
                TextField(
                    "E-mail",
                    text: $viewModel.email
                )
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .privacySensitive()
            }

            RegistrationFieldContainer {
                SecureField(
                    "Senha",
                    text: $viewModel.password
                )
                .textContentType(.newPassword)
                .privacySensitive()
            }

            RegistrationFieldContainer {
                SecureField(
                    "Confirme sua senha",
                    text: $viewModel.passwordConfirmation
                )
                .textContentType(.newPassword)
                .privacySensitive()
            }

            Text(
                "Use pelo menos \(RegistrationViewModel.minimumPasswordLength) caracteres e inclua ao menos um número."
            )
            .font(.caption)
            .foregroundStyle(AppColors.secondaryText)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
        }
    }

    @ViewBuilder
    private var errorSection: some View {
        if let errorMessage = viewModel.errorMessage {
            Text(errorMessage)
                .font(.footnote)
                .foregroundStyle(AppColors.error)
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                .accessibilityLabel(
                    "Erro: \(errorMessage)"
                )
        }
    }

    private var continueButton: some View {
        Button {
            if viewModel.validateAccess() {
                onContinue()
            }
        } label: {
            Text("Continuar")
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .padding(.horizontal, AppSpacing.extraLarge)
        .padding(.vertical, AppSpacing.compact)
        .background(.ultraThinMaterial)
    }

    private var accountTypeTitle: String {
        viewModel.accountType.isPromoter
            ? "Divulgador"
            : "Participante"
    }
}
