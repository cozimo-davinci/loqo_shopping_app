//
//  ProductDetailView.swift
//  loqo
//
//  Created by Teimur Terchyyev on 2025-02-25.
//

import SwiftUI

struct ProductDetailView: View {
    let product: ProductList

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                AsyncImage(url: URL(string: product.image)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .cornerRadius(10)
                } placeholder: {
                    ProgressView()
                }
                .padding()

                Text(product.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)

                Text(String(format: "$%.2f", product.price))
                    .font(.title2)
                    .foregroundColor(.blue)
                    .padding(.horizontal)

                Text(product.description)
                    .font(.body)
                    .padding()

                Spacer()
            }
        }
        .navigationTitle("Product Details")
    }
}

