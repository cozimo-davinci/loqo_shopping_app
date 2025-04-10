import SwiftUI

struct FavoritesView: View {
    @Binding var favorites: Set<Int64>  // Use @Binding to allow mutating the favorites set
    let products: FetchedResults<Product>
    @Binding var shoppingList: Set<Int64>  // Bind the shopping list so items can be added to it
    
    @State private var showingAlert = false
    @State private var selectedProduct: Product? = nil
    @State private var navigateToCart = false  // State to control navigation
    @Binding var path: NavigationPath

    // Filter the products based on the favorites set
    var favoriteProducts: [Product] {
        products.filter { favorites.contains($0.id) } // Assuming your Product has an 'id' of type Int64
    }

    var body: some View {
        NavigationStack {
            VStack {
                Text("Your Favorites")
                    .font(.headline)
                    .padding()
                
                // Filter the products to show only those that are favorites
                let favoriteProducts = products.filter { favorites.contains($0.id) }
                
                if favoriteProducts.isEmpty {
                    Text("No favorites added yet")
                        .foregroundColor(.gray)
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(favoriteProducts) { product in
                                VStack {
                                    if let imageName = product.image {
                                            Image(imageName)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(maxHeight: 400)
                                                .clipped()
                                                .cornerRadius(10)
                                                .background(Color.white)
                                        } else {
                                            Image(systemName: "photo") // Placeholder
                                                .resizable()
                                                .scaledToFill()
                                                .frame(maxHeight: 400)
                                                .clipped()
                                                .cornerRadius(10)
                                                .background(Color.white)
                                                .foregroundColor(.gray)
                                        }
                                    if let title = product.title{
                                        Text(title)
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.black)
                                            .padding(.top, 8)
                                    }
                                    Text("$\(product.price, specifier: "%.2f")")
                                        .font(.headline)
                                        .foregroundColor(.gray)
                                        .padding(.top, 2)
                    
                                    // Heart button to toggle favorites
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
                                   .padding(.top, 8)
                                   
                                   // Add to Bag button
                                   Button(action: {
                                       // Add to shopping list
                                       shoppingList.insert(product.id)
                                       selectedProduct = product
                                       showingAlert = true
                                   }) {
                                       Text("Add to Bag")
                                           .font(.headline)
                                           .foregroundColor(.white)
                                           .padding()
                                           .frame(maxWidth: .infinity)
                                           .background(Color.blue)
                                           .cornerRadius(10)
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
            .navigationTitle("Favorites")
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("\(selectedProduct?.title ?? "") added to your bag!"),
                    message: Text("You can go to your shopping cart to review and checkout."),
                    primaryButton: .default(Text("Go to Cart")) {
                        // Set navigateToCart to true to trigger navigation
                        navigateToCart = true
                    },
                    secondaryButton: .cancel()
                )
            }
            .navigationDestination(isPresented: $navigateToCart) {
                CartView(
                    shoppingList: $shoppingList,
                    products: products,
                    path: $path,
                    resetCart: {}
                )
            }
        }
    }
}
