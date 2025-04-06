
import SwiftUI
import CoreData

// MARK: - Main HomeView
struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Product.title, ascending: true)],
        animation: .default
    ) private var products: FetchedResults<Product>

    @State private var selectedTab = 0
    @State private var searchText = ""
    @State private var favorites: Set<Int64> = []
    @State private var shoppingList: Set<Int64> = []
    @Binding var path: NavigationPath

    // Filtered products based on search
    var filteredProducts: FetchedResults<Product> {
        if searchText.isEmpty {
            return products
        } else {
            let predicate = NSPredicate(format: "title CONTAINS[c] %@", searchText)
            products.nsPredicate = predicate
            return products
        }
    }

    private func resetCart() {
        shoppingList.removeAll()
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            HomeContentView(
                searchText: $searchText,
                shoppingList: $shoppingList,
                favorites: $favorites,
                path: $path,
                products: products,
                filteredProducts: filteredProducts,
                resetCart: resetCart
            )
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            .tag(0)

            // Favorites Tab
            FavoritesView(
                favorites: $favorites,
                products: products,
                shoppingList: $shoppingList,
                path: $path
            )
            .tabItem {
                Image(systemName: "heart")
                Text("Favorites")
            }
            .tag(1)

            // Profile Tab
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
                .tag(2)
        }
        .accentColor(.blue)
        .onChange(of: searchText) { _ in
            products.nsPredicate = filteredProducts.nsPredicate
        }
    }
}

// MARK: - Subviews (All in the same file)

// Home Content (Main Scrollable Area)
struct HomeContentView: View {
    @Binding var searchText: String
    @Binding var shoppingList: Set<Int64>
    @Binding var favorites: Set<Int64>
    @Binding var path: NavigationPath

    var products: FetchedResults<Product>
    var filteredProducts: FetchedResults<Product>
    var resetCart: () -> Void

    var body: some View {
        NavigationStack {
            VStack {
                // Search Bar
                HStack {
                    TextField("Search for products...", text: $searchText)
                        .padding(10)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                }

                // Header with Logo & Cart
                HStack {
                    Spacer()
                    Image("loqo") // Replace with your logo asset
                        .resizable()
                        .scaledToFit()
                        .frame(width: 75, height: 75)
                        .padding(.leading, 40)
                    Spacer()
                    NavigationLink(destination: CartView(
                        shoppingList: $shoppingList,
                        products: products,
                        path: $path,
                        resetCart: resetCart,
                    )) {
                        Image(systemName: "cart")
                            .font(.title)
                            .foregroundColor(.black)
                    }
                    .padding(.trailing, 16)
                }
                .padding(.vertical, 10)

                // Product Grid
                ProductGridView(
                    filteredProducts: filteredProducts,
                    shoppingList: $shoppingList,
                    favorites: $favorites
                )
            }
        }
    }
}

// Product Grid (LazyVGrid Layout)
struct ProductGridView: View {
    var filteredProducts: FetchedResults<Product>
    @Binding var shoppingList: Set<Int64>
    @Binding var favorites: Set<Int64>

    var body: some View {
        Text("Suggested for you")
            .font(.headline)
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 16)

        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(filteredProducts) { product in
                    ProductCardView(
                        product: product,
                        shoppingList: $shoppingList,
                        favorites: $favorites
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
    }
}

// Individual Product Card
struct ProductCardView: View {
    let product: Product
    @Binding var shoppingList: Set<Int64>
    @Binding var favorites: Set<Int64>

    private var productID: Int64 {
            // If your Core Data model has id as optional:
            // return product.id ?? 0
            
            // If your Core Data model has id as non-optional:
            return product.id
        }

    var body: some View {
        VStack {
            // Product Image
            if let imageName = product.image {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(maxHeight: 600)
                    .clipped()
                    .cornerRadius(10)
                    .background(Color.white)
            }

            // Product Title
            if let title = product.title {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding(.top, 8)
            }

            // Price
            Text("$\(product.price, specifier: "%.2f")")
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.top, 2)

            // Cart & Favorites Buttons
            HStack {
                // Add to Cart Button
                Button {
                    // Directly use the ID since we've ensured it exists
                        if shoppingList.contains(productID) {
                            shoppingList.remove(productID)
                        } else {
                            shoppingList.insert(productID)
                        }
                } label: {
                    Image(systemName: shoppingList.contains(product.id ?? 0) ? "cart.fill" : "cart")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .padding(.trailing, 16)
                }

                // Favorite Button - THIS IS WHAT NEEDED FIXING
                   Button {
                       if favorites.contains(productID) {
                           favorites.remove(productID)
                       } else {
                           favorites.insert(productID)
                       }
                   } label: {
                       Image(systemName: favorites.contains(productID) ? "heart.fill" : "heart")
                           .font(.title2)
                           .foregroundColor(.red)
                   }
            }
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity)
    }
}
