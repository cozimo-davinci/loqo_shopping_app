import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var navigateToHome = false
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var path: NavigationPath

    var body: some View {
        NavigationStack {
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
                            navigateToHome = true // Trigger navigation to HomeView
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding()

                NavigationLink(
                    destination: HomeView(path: $path),
                    isActive: $navigateToHome,
                    label: { EmptyView() }
                )
                .hidden() // Hide the NavigationLink itself

                NavigationLink("Don't have an account? Sign Up", destination: SignUpView(path: $path))
                    .padding()
            }
            .padding()
        }
    }
}
