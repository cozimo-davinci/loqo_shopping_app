//
//  ProductCard.swift
//  loqo
//
//  Created by Teimur Terchyyev on 2025-02-25.
//

import SwiftUI

struct ProductCard: View {
    let product: ProductList

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: product.image)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 120)
                    .cornerRadius(10)
            } placeholder: {
                ProgressView()
            }
            Text(product.title)
                .font(.headline)
                .lineLimit(2)
                .multilineTextAlignment(.center)
            Text(String(format: "$%.2f", product.price))
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 2))
    }
}
