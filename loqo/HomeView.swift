//
//  HomeView.swift
//  loqo
//
//  Created by Teimur Terchyyev on 2025-02-25.
//

import SwiftUI

struct HomeView: View {
    @State private var products: [ProductList] = []
    @State private var selectedTab = 0
    let tabs = ["house", "magnifyingglass", "heart", "bell", "person"]

    var body: some View {
        NavigationView {
            VStack {
                // Header
                HStack {
                    Spacer()
                    Image("logo") // Replace with your actual logo asset
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                    Spacer()
                    NavigationLink(destination: CartView()) {
                        Image(systemName: "cart")
                            .font(.title)
                            .foregroundColor(.black)
                    }
                }
                .padding()

                // Product List
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(products, id: \.id) { product in  // Ensure unique ID
                            NavigationLink(destination: ProductDetailView(product: product)) {
                                ProductCard(product: product)
                            }
                        }
                    }
                    .padding()
                }

                // Footer with Tab Bar
                HStack {
                    ForEach(0..<tabs.count, id: \.self) { index in
                        Spacer()
                        Button(action: { selectedTab = index }) {
                            VStack(spacing: 8) {
                                Image(systemName: tabs[index])
                                    .font(.title)
                                    .foregroundColor(selectedTab == index ? .blue : .gray)
                                // Always render the text; if not active, use clear color
                                Text(tabTitle(index))
                                    .font(.caption)
                                    .foregroundColor(selectedTab == index ? .blue : .clear)
                            }
                            .frame(minHeight: 60) // Reserve enough vertical space
                        }
                        Spacer()
                    }
                }
                .frame(height: 80) // Force a fixed footer height
                .background(Color.white.shadow(radius: 2))
                .overlay(
                    Rectangle()
                        .frame(height: 4)
                        .foregroundColor(.black),
                    alignment: .top
                )
            }
            .background(Color.white.edgesIgnoringSafeArea(.all)) // Set full background to white
            .onAppear {
                fetchProducts()
            }
        }
    }

    private func fetchProducts() {
        guard let url = URL(string: "https://fakestoreapi.com/products") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    print("Response received: \(String(data: data, encoding: .utf8) ?? "Invalid Data")") // Debug
                    let decodedProducts = try JSONDecoder().decode([ProductList].self, from: data)
                    DispatchQueue.main.async {
                        self.products = decodedProducts
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            } else if let error = error {
                print("Error fetching data: \(error)")
            }
        }.resume()
    }

    private func tabTitle(_ index: Int) -> String {
        switch index {
        case 0: return "Home"
        case 1: return "Search"
        case 2: return "Favorites"
        case 3: return "Notifications"
        case 4: return "Profile"
        default: return ""
        }
    }
}
