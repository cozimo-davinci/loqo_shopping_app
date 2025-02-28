import SwiftUI

struct CartView: View {
    var body: some View {
        VStack {
            Text("Your Shopping Cart")
                .font(.largeTitle)
                .padding()

            // You can list items in the cart here
            Text("No items in cart yet.") // You can replace this with the cart items if needed
                .font(.headline)
                .padding()

            Spacer()
        }
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
    }
}
