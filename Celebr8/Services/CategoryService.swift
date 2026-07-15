//
//  CategoryService.swift
//  Celebr8
//
//  Created by Arthur Fedeli on 14/07/26.
//

import FirebaseFirestore
import Foundation

final class CategoryService {
    private let database: Firestore
    
    init(database: Firestore) {
        self.database = database
    }
    
    convenience init() {
        self.init(
            database: Firestore.firestore()
        )
    }
    
    func fetchActiveCategories() async throws
    -> [CategoryCatalogItem] {
        let snapshot = try await database
            .collection("eventCategories")
            .whereField("isActive", isEqualTo: true)
            .getDocuments()
        
        let categories = try snapshot.documents.map {
            documentSnapshot in
            
            let document = try documentSnapshot.data(
                as: CategoryDocument.self
            )
            
            return CategoryCatalogItem(
                id: documentSnapshot.documentID,
                displayName: document.displayName,
                sfSymbol: document.sfSymbol,
                sortOrder: document.sortOrder
            )
        }
        
        return categories.sorted {
            $0.sortOrder < $1.sortOrder
        }
    }
}

private struct CategoryDocument: Decodable {
    let displayName: String
    let sfSymbol: String
    let sortOrder: Int
    let isActive: Bool
}
