import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack {
            Text("Login")
                .font(.largeTitle)
                .bold()
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

            Button("Login") {
                authViewModel.login(email: email, password: password) { error in
                    if let error = error {
                        errorMessage = error.localizedDescription
                    } else {
                        errorMessage = nil
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .padding()

            NavigationLink("Don't have an account? Sign Up", destination: SignUpView())
                .padding()
        }
        .padding()
    }
}
