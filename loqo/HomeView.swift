import SwiftUI

struct HomeView: View {
    @State private var products: [ProductList] = [
        ProductList(id: 1, title: "Pants", price: 82, description: "Stylish Pants", category: "Apparel", image: "hm1"),
        ProductList(id: 2, title: "Dress", price: 70, description: "Brown Dress", category: "Apparel", image: "hm2"),
        ProductList(id: 3, title: "Shirt", price: 129, description: "Black Shirt", category: "Apparel", image: "hm3"),
        ProductList(id: 4, title: "T-shirt", price: 62, description: "T-shirt", category: "Footwear", image: "hm4")
    ]
    
    @State private var selectedTab = 0
    @State private var searchText = "" // For storing the search query
    @State private var favorites: Set<Int> = []
    @State private var shoppingList: Set<Int> = []

    // Filter products based on searchText
    var filteredProducts: [ProductList] {
        if searchText.isEmpty {
            return products
        } else {
            return products.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    // Define the resetCart closure
    private func resetCart() {
        shoppingList.removeAll()  // Clear shopping list
        for index in products.indices {
            products[index].quantity = 1  // Reset product quantities (or to the default value you desire)
        }
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Content
            NavigationStack {
                VStack {
                    // **Search Bar**
                    HStack {
                        TextField("Search for products...", text: $searchText)
                            .padding(10)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .padding(.horizontal, 16)
                            .padding(.top, 16)
                    }

                    // **Header with Centered Logo**
                    HStack {
                        Spacer()
                        Image("loqo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 75, height: 75)
                            .padding(.leading, 40) // Pushes the image more toward center
                        Spacer()
                        NavigationLink(destination: CartView(
                            shoppingList: $shoppingList,
                            products: $products,
                            resetCart: resetCart // Pass the resetCart closure here
                        )) {
                            Image(systemName: "cart")
                                .font(.title)
                                .foregroundColor(.black)
                        }
                        .padding(.trailing, 16)
                    }
                    .padding(.vertical, 10)

                    // **Product Grid**
                    Text("Suggested for you")
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 16)

                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(filteredProducts) { product in
                                VStack {
                                    Image(product.image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(maxHeight: 600)
                                        .clipped()
                                        .cornerRadius(10)
                                        .background(Color.white)

                                    Text(product.title)
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)
                                        .padding(.top, 8)

                                    Text("$\(product.price, specifier: "%.2f")")
                                        .font(.headline)
                                        .foregroundColor(.gray)
                                        .padding(.top, 2)

                                    // **Add to Cart Button**
                                    HStack {
                                        Button(action: {
                                            if shoppingList.contains(product.id) {
                                                shoppingList.remove(product.id)
                                            } else {
                                                shoppingList.insert(product.id)
                                            }
                                        }) {
                                            Image(systemName: shoppingList.contains(product.id) ? "cart.fill" : "cart")
                                                .font(.title2)
                                                .foregroundColor(.blue)
                                                .padding(.trailing, 16)
                                        }

                                        Button(action: {
                                            if favorites.contains(product.id) {
                                                favorites.remove(product.id)
                                            } else {
                                                favorites.insert(product.id)
                                            }
                                        }) {
                                            Image(systemName: favorites.contains(product.id) ? "heart.fill" : "heart")
                                                .font(.title2)
                                                .foregroundColor(.red)
                                        }
                                    }
                                    .padding(.top, 8)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                    }
                }
            }
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            .tag(0)
            
            // **Favorites View** - Now passing the favorites as a binding
            FavoritesView(favorites: $favorites, products: products, shoppingList: $shoppingList)
                .tabItem {
                    Image(systemName: "heart")
                    Text("Favorites")
                }
                .tag(2)
            
            // **Profile Tab**
            ProfileView()
            .tabItem {
                Image(systemName: "person")
                Text("Profile")
            }
            .tag(3)
        }
        .accentColor(.blue) // Highlight selected tab in blue
    }
}
