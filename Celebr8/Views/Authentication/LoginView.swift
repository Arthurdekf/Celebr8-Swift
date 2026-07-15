//
//  LoginView.swift
//  Celebr8
//
//  Created by Arthur Fedeli on 11/07/26.
//

import SwiftUI

@MainActor
struct LoginView: View {
    @State private var showsPassword = false
    @State private var viewModel = LoginViewModel()
    
    private let onSignInCompleted: (AppUser) -> Void
    private let onCreateAccount: () -> Void
    
    init(
        onSignInCompleted: @escaping (AppUser) -> Void,
        onCreateAccount: @escaping () -> Void
    ) {
        self.onSignInCompleted = onSignInCompleted
        self.onCreateAccount = onCreateAccount
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.extraLarge) {
                Spacer(minLength: AppSpacing.huge)
                
                BrandLogo(size: 56)
                
                VStack(spacing: AppSpacing.small) {
                    Text("Acesse sua conta")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text(
                        "Entre com seu e-mail e senha para continuar."
                    )
                    .font(.body)
                    .foregroundStyle(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                }
                
                VStack(spacing: AppSpacing.small) {
                    VStack(spacing: 0) {
                        TextField(
                            "E-mail",
                            text: $viewModel.email
                        )
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding(.horizontal, AppSpacing.medium)
                        .padding(.vertical, AppSpacing.compact)
                        .privacySensitive()
                        
                        if showsPassword {
                            Divider()
                                .padding(.leading, AppSpacing.medium)
                            
                            SecureField(
                                "Senha",
                                text: $viewModel.password
                            )
                            .textContentType(.password)
                            .padding(.horizontal, AppSpacing.medium)
                            .padding(.vertical, AppSpacing.compact)
                            .privacySensitive()
                            .transition(
                                .move(edge: .top)
                                .combined(with: .opacity)
                            )
                        }
                    }
                    .background(
                        AppColors.secondaryBackground,
                        in: RoundedRectangle(
                            cornerRadius: AppRadius.medium,
                            style: .continuous
                        )
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: AppRadius.medium,
                            style: .continuous
                        )
                    )
                    .animation(
                        .snappy,
                        value: showsPassword
                    )
                    
                    if showsPassword {
                        Button("Esqueci minha senha?") {
                            Task {
                                await viewModel.sendPasswordReset()
                            }
                        }
                        .fontWeight(.bold)
                        .frame(
                            maxWidth: .infinity,
                            alignment: .trailing
                        )
                        .transition(.opacity)
                    }
                }
                
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
                
                if let confirmationMessage =
                    viewModel.confirmationMessage {
                    Text(confirmationMessage)
                        .font(.footnote)
                        .foregroundStyle(AppColors.secondaryText)
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                }
                
                VStack(spacing: AppSpacing.extraLarge) {
                    Button {
                        if showsPassword {
                            Task {
                                if let user = await viewModel.signIn() {
                                    onSignInCompleted(user)
                                }
                            }
                        } else {
                            withAnimation(.snappy) {
                                showsPassword = true
                            }
                        }
                    } label: {
                        Group {
                            if viewModel.isLoading {
                                ProgressView()
                            } else {
                                Text(showsPassword ? "Entrar" : "Continuar")
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .disabled(
                        !showsPassword && !viewModel.canRevealPassword
                    )
                    
                    HStack(spacing: AppSpacing.medium) {
                        Rectangle()
                            .fill(AppColors.separator)
                            .frame(
                                width: 100,
                                height: 1
                            )
                        
                        Text("OU")
                            .font(.footnote)
                            .fontWeight(.medium)
                            .foregroundStyle(AppColors.secondaryText)
                        
                        Rectangle()
                            .fill(AppColors.separator)
                            .frame(
                                width: 100,
                                height: 1
                            )
                    }
                    .padding(.top, AppSpacing.section)
                    .accessibilityElement(children: .combine)
                    
                    Button {
                        onCreateAccount()
                    } label: {
                        Label(
                            "Criar uma conta",
                            systemImage: "pencil"
                        )
                    }
                    .fontWeight(.bold)
                    .padding(.top, AppSpacing.extraLarge)
                }
                .padding(.top, AppSpacing.small)
                
            }
            .padding(.horizontal, AppSpacing.extraLarge)
        }
        .scrollBounceBehavior(.basedOnSize)
        .scrollDismissesKeyboard(.interactively)
        .disabled(viewModel.isLoading)
    }
}

#Preview {
    LoginView(
        onSignInCompleted: { _ in },
        onCreateAccount: {}
    )
}
