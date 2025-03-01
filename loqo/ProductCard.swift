import SwiftUI

struct ProductCard: View {
    var product: ProductList
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: product.image)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
            } placeholder: {
                ProgressView() // Show a loading spinner while the image is loading
            }
            
            Text(product.title)
                .font(.headline)
                .lineLimit(2)
            
            Text("$\(product.price, specifier: "%.2f")")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 4)
    }
}
