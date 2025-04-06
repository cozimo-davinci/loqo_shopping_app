import SwiftUI

struct CongratulationsView: View {
    var resetCart: () -> Void
    @Binding var path: NavigationPath
    @Environment(\.presentationMode) var presentationMode // Use this for dismissing the view

    var body: some View {
        VStack {
            Spacer()

            Text("🎉 Congratulations! 🎉")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()

            Text("Your order has been successfully placed!")
                .font(.title2)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .padding(.bottom, 30)

            Button(action: {
                resetCart()
                presentationMode.wrappedValue.dismiss()  // ✅ Go back in NavigationStack
            }) {
                Text("Continue Shopping")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)

            Spacer()
        }
        .navigationTitle("Thank You")
    }
}

// MARK: - Preview
struct CongratulationsView_Previews: PreviewProvider {
    static var previews: some View {
        CongratulationsView(resetCart: {}, path: .constant(NavigationPath()))
    }
}
