import SwiftUI

struct CartView: View {
    @Binding var shoppingList: Set<Int>
    @Binding var products: [ProductList]

    let taxRate = 0.13  // 13% tax rate

    var cartItems: [ProductList] {
        products.filter { shoppingList.contains($0.id) }
    }

    var subtotal: Double {
        cartItems.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
    }

    var tax: Double {
        subtotal * taxRate
    }

    var totalPrice: Double {
        subtotal + tax
    }

    @State private var showingAlert = false
    @State private var itemToRemove: ProductList? = nil

    var resetCart: () -> Void  // Reset the cart when proceeding to checkout
    
    var body: some View {
        VStack {
            Text("Your Shopping Cart")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)

            if cartItems.isEmpty {
                VStack {
                    Text("Your cart is empty 🛒")
                        .font(.title2)
                        .foregroundColor(.gray)
                        .padding()
                }
            } else {
                List {
                    ForEach(cartItems) { product in
                        HStack(spacing: 15) {
                            Image(product.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .cornerRadius(10)

                            VStack(alignment: .leading, spacing: 5) {
                                Text(product.title)
                                    .font(.headline)

                                Text("$\(product.price, specifier: "%.2f") each")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)

                                Text("Quantity: \(product.quantity)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)

                                Text("Total: $\(Double(product.quantity) * product.price, specifier: "%.2f")")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                            }
                            
                            Spacer()

                            // Quantity Buttons
                            HStack(spacing: 10) {
                                Button(action: {
                                    if product.quantity > 1 {
                                        if let index = products.firstIndex(where: { $0.id == product.id }) {
                                            products[index].quantity -= 1
                                        }
                                    }
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.gray)
                                }
                                .buttonStyle(PlainButtonStyle()) // Prevent row tap

                                Button(action: {
                                    if let index = products.firstIndex(where: { $0.id == product.id }) {
                                        products[index].quantity += 1
                                    }
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.blue)
                                }
                                .buttonStyle(PlainButtonStyle()) // Prevent row tap
                            }
                            
                            // Remove Button
                            Button(action: {
                                itemToRemove = product
                                showingAlert = true
                            }) {
                                Image(systemName: "trash.fill")
                                    .font(.title2)
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(PlainButtonStyle()) // Prevent row tap
                        }
                        .padding(.vertical, 8)
                        .contentShape(Rectangle()) // Make the entire row tappable
                    }
                }
                .listStyle(PlainListStyle()) // Make it look cleaner
            }

            // Pricing Breakdown
            VStack(alignment: .leading, spacing: 8) {
                Divider()
                
                HStack {
                    Text("Subtotal:")
                    Spacer()
                    Text("$\(subtotal, specifier: "%.2f")")
                }
                
                HStack {
                    Text("Tax (13%):")
                    Spacer()
                    Text("$\(tax, specifier: "%.2f")")
                }
                
                HStack {
                    Text("Total:")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                    Text("$\(totalPrice, specifier: "%.2f")")
                        .font(.title2)
                        .fontWeight(.bold)
                }
            }
            .padding(.horizontal, 16)

            Spacer()
            
            // Checkout Button
            if !cartItems.isEmpty {
                NavigationLink(destination: CongratulationsView(resetCart: resetCart)) {
                    Text("Proceed to Checkout")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
                .simultaneousGesture(TapGesture().onEnded {
                    // Call resetCart to empty the cart when proceeding to checkout
                    resetCart()
                })
            }
        }
        .navigationTitle("Cart")
        .padding()
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Remove Item"),
                message: Text("Are you sure you want to remove this item from your shopping list?"),
                primaryButton: .destructive(Text("Remove")) {
                    if let productToRemove = itemToRemove {
                        shoppingList.remove(productToRemove.id)
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
}
