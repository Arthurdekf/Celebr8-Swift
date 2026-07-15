//
//  CategoryCatalogViewModel.swift
//  Celebr8
//
//  Created by Arthur Fedeli on 14/07/26.
//

import Observation

@MainActor
@Observable
final class CategoryCatalogViewModel {
    private(set) var categories: [CategoryCatalogItem] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    
    private let categoryService: CategoryService
    
    init(categoryService: CategoryService) {
        self.categoryService = categoryService
    }
    
    convenience init() {
        self.init(
            categoryService: CategoryService()
        )
    }
    
    func loadCategories() async {
        guard categories.isEmpty, !isLoading else {
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        defer {
            isLoading = false
        }
        
        do {
            let categories = try await categoryService.fetchActiveCategories()
            
            guard !categories.isEmpty else {
                errorMessage = "Nenhuma categoria está disponível no momento."
                return
            }
            
            self.categories = categories
        } catch {
            errorMessage = "Não foi possível carregar as categorias. Tente novamente."
        }
    }
}
