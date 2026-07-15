//
//  RegistrationCategoriesView.swift
//  Celebr8
//
//  Created by Arthur Fedeli on 14/07/26.
//

import SwiftUI

@MainActor
struct RegistrationCategoriesView: View {
    @Bindable var viewModel: RegistrationViewModel
    @State private var catalogViewModel =
    CategoryCatalogViewModel()
    
    let onRegistrationCompleted: (AppUser) -> Void
    
    var body: some View {
        ScrollView {
            VStack(
                alignment: .leading,
                spacing: AppSpacing.section
            ) {
                header
                categories
                errorSection
            }
            .padding(.horizontal, AppSpacing.extraLarge)
            .padding(.top, AppSpacing.small)
            .padding(.bottom, AppSpacing.medium)
        }
        .safeAreaInset(edge: .bottom) {
            registrationButton
        }
        .navigationTitle("Seus interesses")
        .navigationBarTitleDisplayMode(.inline)
        .disabled(viewModel.isLoading)
        .task {
            await catalogViewModel.loadCategories()
        }
    }
    
    private var header: some View {
        VStack(spacing: AppSpacing.small) {
            BrandLogo(size: 34)
            
            Text("O que você gosta?")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(
                "Escolha de \(RegistrationViewModel.minimumCategoryCount) a \(RegistrationViewModel.maximumCategoryCount) categorias para personalizar suas recomendações."
            )
            .foregroundStyle(AppColors.secondaryText)
            .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private var categories: some View {
        if catalogViewModel.isLoading &&
            catalogViewModel.categories.isEmpty {
            ProgressView("Carregando categorias...")
                .frame(
                    maxWidth: .infinity,
                    minHeight: 200
                )
        } else if let errorMessage =
                    catalogViewModel.errorMessage {
            VStack(spacing: AppSpacing.medium) {
                Image(systemName: "wifi.exclamationmark")
                    .font(.largeTitle)
                    .foregroundStyle(AppColors.secondaryText)
                
                Text(errorMessage)
                    .foregroundStyle(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                
                Button("Tentar novamente") {
                    Task {
                        await catalogViewModel.loadCategories()
                    }
                }
                .buttonStyle(.bordered)
            }
            .frame(
                maxWidth: .infinity,
                minHeight: 200
            )
        } else {
            categoryGrid
        }
    }
    
    private var categoryGrid: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.medium
        ) {
            LazyVGrid(
                columns: [
                    GridItem(
                        .adaptive(minimum: 92),
                        spacing: AppSpacing.small
                    )
                ],
                spacing: AppSpacing.small
            ) {
                ForEach(catalogViewModel.categories) {
                    category in
                    
                    categoryButton(category)
                }
            }
            
            Text(
                "\(viewModel.selectedCategoryIDs.count) de \(RegistrationViewModel.maximumCategoryCount) selecionadas"
            )
            .font(.caption)
            .foregroundStyle(AppColors.secondaryText)
            .frame(
                maxWidth: .infinity,
                alignment: .trailing
            )
        }
    }
    
    @ViewBuilder
    private var errorSection: some View {
        if let errorMessage = viewModel.errorMessage {
            Text(errorMessage)
                .font(.footnote)
                .foregroundStyle(AppColors.error)
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityLabel("Erro: \(errorMessage)")
        }
    }
    
    private var registrationButton: some View {
        Button {
            Task {
                if let user = await viewModel.register() {
                    onRegistrationCompleted(user)
                }
            }
        } label: {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Text("Criar conta")
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .disabled(
            viewModel.selectedCategoryIDs.count <
            RegistrationViewModel.minimumCategoryCount
        )
        .padding(.horizontal, AppSpacing.extraLarge)
        .padding(.vertical, AppSpacing.compact)
        .background(.ultraThinMaterial)
    }
    
    private func categoryButton(
        _ category: CategoryCatalogItem
    ) -> some View {
        let isSelected =
        viewModel.isCategorySelected(
            id: category.id
        )
        
        return Button {
            withAnimation(.snappy) {
                viewModel.toggleCategory(
                    id: category.id
                )
            }
        } label: {
            Label(
                category.displayName,
                systemImage: category.sfSymbol
            )
            .font(.subheadline)
            .fontWeight(
                isSelected ? .semibold : .regular
            )
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, minHeight: 44)
            .padding(.horizontal, AppSpacing.compact)
            .background(
                isSelected
                ? AppColors.brand
                : AppColors.secondaryBackground,
                in: Capsule()
            )
            .foregroundStyle(
                isSelected
                ? Color.white
                : AppColors.primaryText
            )
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(
            isSelected ? .isSelected : []
        )
    }
}

