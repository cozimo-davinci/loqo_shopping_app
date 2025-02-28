//
//  Product.swift
//  loqo
//
//  Created by Teimur Terchyyev on 2025-02-25.
//

import Foundation

struct ProductList: Identifiable, Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    
}
