import SwiftUI

struct PaymentView: View {
    @Environment(\.presentationMode) var presentationMode
    var totalPrice: Double
    var resetCart: () -> Void
    @Binding var path: NavigationPath

    @State private var cardNumber = ""
    @State private var expiryDate = ""
    @State private var cvv = ""

    @State private var showAlert = false
    @State private var alertMessage = ""

    @State private var navigateToCongrats = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Payment Details")
                .font(.largeTitle)
                .bold()

            TextField("Card Number (16 digits)", text: $cardNumber)
                .keyboardType(.numberPad)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)

            TextField("Expiry Date (MM/YY)", text: $expiryDate)
                .keyboardType(.numbersAndPunctuation)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)

            SecureField("CVV (3 digits)", text: $cvv)
                .keyboardType(.numberPad)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)

            Button("Confirm Payment ($\(totalPrice, specifier: "%.2f"))") {
                if validateInputs() {
                    // Reset card info
                    cardNumber = ""
                    expiryDate = ""
                    cvv = ""

                    // Reset cart
                    resetCart()

                    // Navigate to Congrats View
                    navigateToCongrats = true
                } else {
                    showAlert = true
                }
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.green)
            .cornerRadius(10)

            NavigationLink(destination: CongratulationsView(resetCart: resetCart, path: $path), isActive: $navigateToCongrats) {
                EmptyView()
            }

            Spacer()
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Invalid Input"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    func validateInputs() -> Bool {
        guard cardNumber.count == 16, cardNumber.allSatisfy({ $0.isNumber }) else {
            alertMessage = "Invalid Card Number"
            return false
        }

        let expiryRegex = #"^(0[1-9]|1[0-2])\/\d{2}$"#
        if expiryDate.range(of: expiryRegex, options: .regularExpression) == nil {
            alertMessage = "Invalid Expiry Date (MM/YY)"
            return false
        }

        guard cvv.count == 3, cvv.allSatisfy({ $0.isNumber }) else {
            alertMessage = "Invalid CVV"
            return false
        }

        return true
    }
}
