import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var user: User?

    init() {
        // Observe the auth state and update the user object when it changes
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.user = user
        }
    }

    func signUp(firstName: String, lastName: String, phoneNumber: String, email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                if let authError = error as NSError?, authError.code == AuthErrorCode.emailAlreadyInUse.rawValue {
                    completion(NSError(domain: "AuthError", code: authError.code, userInfo: [NSLocalizedDescriptionKey: "This email is already registered. Please try another one."]))
                    return
                }
                completion(error)
                return
            }
            
            guard let user = result?.user else {
                completion(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "User creation failed"]))
                return
            }
            
            // Store additional user information in Firestore
            let db = Firestore.firestore()
            let userData: [String: Any] = [
                "firstName": firstName,
                "lastName": lastName,
                "phoneNumber": phoneNumber,
                "email": email
            ]
            
            db.collection("users").document(user.uid).setData(userData) { error in
                if let error = error {
                    completion(error)
                } else {
                    // Send email verification
                    user.sendEmailVerification { error in
                        if let error = error {
                            completion(error)
                            return
                        }
                        
                        self.user = user  // Update the user object with the authenticated user
                        completion(nil)    // Indicate success
                    }
                }
            }
        }
    }

    // Login method
    func login(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion(error)
                return
            }
            
            self?.user = result?.user
            completion(nil)
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
        } catch {
            print("Error signing out: \(error)")
        }
    }
}
