//
//  RegistrationProfileView.swift
//  Celebr8
//
//  Created by Arthur Fedeli on 15/07/26.
//

import PhotosUI
import SwiftUI

@MainActor
struct RegistrationProfileView: View {
    @Bindable var viewModel: RegistrationViewModel
    
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedPhotoData: Data?
    @State private var showsCategorySelection = false
    
    @State private var showsBirthDatePicker = false
    @State private var draftBirthDate =
    Calendar.current.date(
        byAdding: .year,
        value: -18,
        to: Date()
    ) ?? Date()
    
    let onRegistrationCompleted: (AppUser) -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.section) {
                header
                profileSection
                personalInformationSection
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
        .navigationDestination(
            isPresented: $showsCategorySelection
        ) {
            RegistrationCategoriesView(
                viewModel: viewModel,
                onRegistrationCompleted:
                    onRegistrationCompleted
            )
        }
        .disabled(viewModel.isLoading)
        .onChange(of: selectedPhotoItem) {
            _, newItem in
            
            Task {
                selectedPhotoData = try? await newItem?
                    .loadTransferable(type: Data.self)
            }
        }
    }
    
    private var header: some View {
        VStack(spacing: AppSpacing.small) {
            BrandLogo(size: 34)
            
            Text(accountTypeTitle)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(AppColors.brand)
            
            Text(
                "Preencha seus dados para começar a usar o Celebr8."
            )
            .foregroundStyle(AppColors.secondaryText)
            .multilineTextAlignment(.center)
        }
    }
    
    private var profileSection: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.medium
        ) {
            sectionTitle("Perfil")
            
            HStack(spacing: AppSpacing.medium) {
                profilePhotoPicker
                
                RegistrationFieldContainer {
                    TextField(
                        "Nome completo",
                        text: $viewModel.displayName
                    )
                    .textContentType(.name)
                }
            }
            
            RegistrationFieldContainer {
                TextField(
                    "Nome de usuário",
                    text: $viewModel.username
                )
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            }
            
            ZStack(alignment: .topLeading) {
                if viewModel.bio.isEmpty {
                    Text("Bio")
                        .foregroundStyle(
                            AppColors.tertiaryText
                        )
                        .padding(.top, AppSpacing.compact)
                        .padding(.leading, AppSpacing.extraSmall)
                }
                
                TextEditor(text: $viewModel.bio)
                    .frame(minHeight: 90)
                    .scrollContentBackground(.hidden)
            }
            .padding(.horizontal, AppSpacing.compact)
            .background(
                AppColors.secondaryBackground,
                in: RoundedRectangle(
                    cornerRadius: AppRadius.medium,
                    style: .continuous
                )
            )
            
            Text(
                "\(viewModel.bio.count)/\(RegistrationViewModel.maximumBioLength)"
            )
            .font(.caption)
            .foregroundStyle(
                viewModel.bio.count >
                RegistrationViewModel.maximumBioLength
                ? AppColors.error
                : AppColors.secondaryText
            )
            .frame(
                maxWidth: .infinity,
                alignment: .trailing
            )
        }
    }
    
    private var profilePhotoPicker: some View {
        let photoData = selectedPhotoData
        
        return PhotosPicker(
            selection: $selectedPhotoItem,
            matching: .images
        ) {
            ZStack {
                Circle()
                    .fill(AppColors.secondaryBackground)
                
                if let photoData,
                   let image = UIImage(
                    data: photoData
                   ) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                } else {
                    Image(systemName: "camera.fill")
                        .font(.title2)
                        .foregroundStyle(
                            AppColors.secondaryText
                        )
                }
            }
            .frame(width: 76, height: 76)
            .overlay(alignment: .bottomTrailing) {
                Image(systemName: "plus.circle.fill")
                    .font(.title3)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(
                        .white,
                        AppColors.brand
                    )
            }
        }
        .accessibilityLabel("Selecionar foto de perfil")
    }
    
    private var personalInformationSection: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.medium
        ) {
            sectionTitle("Informações pessoais")
            
            genderMenu
            
            Button {
                withAnimation(.snappy) {
                    showsBirthDatePicker.toggle()
                }
            } label: {
                HStack {
                    Image(systemName: "calendar")
                    
                    Text(
                        viewModel.birthDate?.formatted(
                            date: .long,
                            time: .omitted
                        ) ?? "Data de nascimento"
                    )
                    
                    Spacer()
                    
                    Image(
                        systemName: showsBirthDatePicker
                        ? "chevron.up"
                        : "chevron.down"
                    )
                    .font(.footnote)
                }
            }
            .buttonStyle(.plain)
            .foregroundStyle(
                viewModel.birthDate == nil
                ? AppColors.secondaryText
                : AppColors.primaryText
            )
            .padding(AppSpacing.medium)
            .background(
                AppColors.secondaryBackground,
                in: RoundedRectangle(
                    cornerRadius: AppRadius.medium,
                    style: .continuous
                )
            )
            
            if showsBirthDatePicker {
                VStack(spacing: AppSpacing.medium) {
                    DatePicker(
                        "Data de nascimento",
                        selection: $draftBirthDate,
                        in: ...Date(),
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                    
                    Button("Confirmar data") {
                        viewModel.birthDate = draftBirthDate
                        
                        withAnimation(.snappy) {
                            showsBirthDatePicker = false
                        }
                    }
                    .fontWeight(.semibold)
                }
                .transition(.opacity)
            }
        }
    }
    
    private var genderMenu: some View {
        Menu {
            ForEach(UserGender.allCases) { gender in
                Button {
                    viewModel.gender = gender
                } label: {
                    if viewModel.gender == gender {
                        Label(
                            gender.displayName,
                            systemImage: "checkmark"
                        )
                    } else {
                        Text(gender.displayName)
                    }
                }
            }
        } label: {
            HStack {
                Image(systemName: "person")
                
                Text(
                    viewModel.gender?.displayName
                    ?? "Selecione seu gênero"
                )
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .font(.footnote)
            }
            .foregroundStyle(
                viewModel.gender == nil
                ? AppColors.secondaryText
                : AppColors.primaryText
            )
            .padding(AppSpacing.medium)
            .background(
                AppColors.secondaryBackground,
                in: RoundedRectangle(
                    cornerRadius: AppRadius.medium,
                    style: .continuous
                )
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
            if viewModel.validateProfile() {
                showsCategorySelection = true
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
    
    private func sectionTitle(
        _ title: String
    ) -> some View {
        Text(title)
            .font(.headline)
    }
}

