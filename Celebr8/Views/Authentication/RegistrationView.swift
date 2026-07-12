//
//  RegistrationView.swift
//  Celebr8
//
//  Created by Arthur Fedeli on 11/07/26.
//

import SwiftUI

@MainActor
struct RegistrationView: View {
    @State private var viewModel = RegistrationViewModel()

    let onRegistrationCompleted: (AppUser) -> Void

    init(
        onRegistrationCompleted: @escaping (AppUser) -> Void = { _ in }
    ) {
        self.onRegistrationCompleted = onRegistrationCompleted
    }

    var body: some View {
        Form {
            Section {
                HStack {
                    Spacer()
                    BrandLogo(size: 48)
                    Spacer()
                }
                .listRowBackground(Color.clear)
            }

            Section("Perfil") {
                TextField(
                    "Nome",
                    text: $viewModel.displayName
                )
                .textContentType(.name)

                TextField(
                    "Nome de usuário",
                    text: $viewModel.username
                )
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            }

            Section {
                TextField(
                    "E-mail",
                    text: $viewModel.email
                )
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()

                SecureField(
                    "Senha",
                    text: $viewModel.password
                )
                .textContentType(.newPassword)

                SecureField(
                    "Confirme sua senha",
                    text: $viewModel.passwordConfirmation
                )
                .textContentType(.newPassword)
            } header: {
                Text("Acesso")
            } footer: {
                Text("A senha deve ter pelo menos 8 caracteres.")
            }

            if let errorMessage = viewModel.errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundStyle(AppColors.error)
                        .accessibilityLabel(
                            "Erro: \(errorMessage)"
                        )
                }
            }

            Section {
                Button {
                    Task {
                        if let user = await viewModel.register() {
                            onRegistrationCompleted(user)
                        }
                    }
                } label: {
                    HStack {
                        Spacer()

                        if viewModel.isLoading {
                            ProgressView()
                        } else {
                            Text("Criar conta")
                                .fontWeight(.semibold)
                        }

                        Spacer()
                    }
                }
            }
        }
        .navigationTitle("Criar conta")
        .navigationBarTitleDisplayMode(.inline)
        .disabled(viewModel.isLoading)
    }
}

#Preview {
    NavigationStack {
        RegistrationView()
    }
}
