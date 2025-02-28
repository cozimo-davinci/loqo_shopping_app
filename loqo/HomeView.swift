import SwiftUI

struct HomeView: View {
    @State private var products: [Product] = [
        Product(id: 1, name: "Jacket", price: "$82", imageName: "hm1"),
        Product(id: 2, name: "Pants", price: "$70", imageName: "hm2"),
        Product(id: 3, name: "Tshirt", price: "$52", imageName: "hm3"),
        Product(id: 4, name: "Jacket", price: "$129", imageName: "hm4")
    ]
    @State private var selectedTab = 0
    let tabs = ["house", "magnifyingglass", "heart", "bell", "person"]
    @State private var favorites: Set<Int> = [] // To track favorite products
    @State private var shoppingList: Set<Int> = [] // To track products added to shopping list

    var body: some View {
        NavigationView {
            VStack {
                // **Header with Logo in Top Right**
                HStack {
                    Spacer()
                    NavigationLink(destination: CartView()) {
                        Image(systemName: "cart")
                            .font(.title)
                            .foregroundColor(.black)
                    }
                    Image("loqo") // Ensure "loqo" exists in Assets.xcassets
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .padding(.trailing, 16)
                }
                .padding()

                // **Title**
                Text("Suggested for you")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 16)

                // **Product List with Flexible Grid Layout**
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible()), // First column
                        GridItem(.flexible())  // Second column
                    ], spacing: 16) {
                        ForEach(products) { product in
                            VStack {
                                // **Image Covering Full Grid Space with Height Coverage**
                                Image(product.imageName)
                                    .resizable()
                                    .scaledToFill() // Ensures the image fills the container
                                    .frame(maxHeight: 600) // Ensure max height is covered
                                    .clipped() // Clips the image if it exceeds the bounds
                                    .cornerRadius(10)
                                    .background(Color.white)

                                // **Product Name and Price with Increased Size**
                                Text(product.name)
                                    .font(.title3) // Increased font size for name
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                                    .padding(.top, 8)

                                Text(product.price)
                                    .font(.headline) // Increased font size for price
                                    .foregroundColor(.gray)
                                    .padding(.top, 2)

                                // **Add to Cart and Favorite Buttons**
                                HStack {
                                    // Add to shopping list button (Cart)
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

                                    // Add to favorites button (Heart)
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
                                .padding(.top, 8) // Spacing between buttons and price
                            }
                            .frame(maxWidth: .infinity) // Ensures each product takes full available width
                        }
                    }
                    .padding(.horizontal, 16) // Adds spacing on the sides
                    .padding(.vertical, 10)   // Adds vertical spacing
                }

                // **Bottom Tab Bar - Improved Layout**
                HStack {
                    ForEach(0..<tabs.count, id: \.self) { index in
                        Button(action: { selectedTab = index }) {
                            VStack(spacing: 4) {
                                Image(systemName: tabs[index])
                                    .font(.title2)
                                    .foregroundColor(selectedTab == index ? .blue : .gray)
                                Text(tabTitle(index))
                                    .font(.caption)
                                    .foregroundColor(selectedTab == index ? .blue : .gray)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
                .frame(height: 70) // Slightly taller for a more balanced look
                .background(Color.white.shadow(radius: 2)) // Light gray background for a modern look
                .cornerRadius(15)
                .shadow(radius: 2)
            }
            .background(Color.white.edgesIgnoringSafeArea(.all))
        }
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

// **Product Model**
struct Product: Identifiable {
    let id: Int
    let name: String
    let price: String
    let imageName: String
}
