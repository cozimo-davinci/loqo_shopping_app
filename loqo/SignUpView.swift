import SwiftUI

struct SignUpView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var phoneNumber = ""
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var showVerificationAlert = false
    @State private var navigateToLogin = false
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            VStack {
                Text("Sign Up")
                    .font(.largeTitle)
                    .bold()
                    .padding()

                TextField("First Name", text: $firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Last Name", text: $lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Phone Number (Optional)", text: $phoneNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding()

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                Button("Sign Up") {
                    authViewModel.signUp(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email, password: password) { error in
                        if let error = error {
                            errorMessage = error.localizedDescription
                        } else {
                            errorMessage = nil
                            showVerificationAlert = true
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding()
                .alert(isPresented: $showVerificationAlert) {
                    Alert(
                        title: Text("Verify Your Email"),
                        message: Text("A verification email has been sent to \(email). Please verify your email before logging in."),
                        dismissButton: .default(Text("OK")) {
                            navigateToLogin = true
                        }
                    )
                }

                NavigationLink(
                    destination: LoginView(),
                    isActive: $navigateToLogin,
                    label: { EmptyView() }
                )
                .hidden()
                
                NavigationLink("Already have an account? Login", destination: LoginView())
                    .padding()
            }
            .padding()
        }
    }
}
