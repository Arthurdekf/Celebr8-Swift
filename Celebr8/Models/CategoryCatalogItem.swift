//
//  CategoryCatalogItem.swift
//  Celebr8
//
//  Created by Arthur Fedeli on 14/07/26.
//

struct CategoryCatalogItem:
    Identifiable,
    Hashable,
    Sendable
{
    let id: String
    let displayName: String
    let sfSymbol: String
    let sortOrder: Int
}
