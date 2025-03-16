import Foundation
import FirebaseAuth
import FirebaseFirestore

struct UserProfile {
    var firstName: String
    var lastName: String
    var phoneNumber: String
    var email: String
}

class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var userProfile: UserProfile?
    
    init() {
        self.user = Auth.auth().currentUser
        if let user = self.user, user.isEmailVerified {
            fetchUserProfile(uid: user.uid)
        }
    }
    
    func fetchUserProfile(uid: String) {
        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                let firstName = data?["firstName"] as? String ?? "Unknown"
                let lastName = data?["lastName"] as? String ?? ""
                
                let profile = UserProfile(
                    firstName: firstName,
                    lastName: lastName,
                    phoneNumber: data?["phoneNumber"] as? String ?? "No Phone",
                    email: data?["email"] as? String ?? "No Email"
                )
                DispatchQueue.main.async {
                    self.userProfile = profile
                }
            } else {
                print("Error fetching profile: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    func updateUserProfile(completion: @escaping (Bool) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(false)
            return
        }
        
        guard let updatedProfile = userProfile else {
            completion(false)
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).updateData([
            "firstName": updatedProfile.firstName,
            "lastName": updatedProfile.lastName,
            "phoneNumber": updatedProfile.phoneNumber,
            "email": updatedProfile.email
        ]) { error in
            if let error = error {
                print("Error updating profile: \(error.localizedDescription)")
                completion(false)
            } else {
                DispatchQueue.main.async {
                    self.userProfile = updatedProfile
                }
                completion(true)
            }
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
                    user.sendEmailVerification { error in
                        if let error = error {
                            completion(error)
                            return
                        }
                        
                        DispatchQueue.main.async {
                            self.user = nil
                        }
                        completion(nil)
                    }
                }
            }
        }
    }

    func login(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion(error)
                return
            }
            
            guard let user = result?.user else {
                completion(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "User login failed"]))
                return
            }
            
            user.reload { _ in
                if !user.isEmailVerified {
                    completion(NSError(domain: "AuthError", code: -2, userInfo: [NSLocalizedDescriptionKey: "Please verify your email before logging in. A verification email has been sent to your inbox."]))
                    try? Auth.auth().signOut()
                } else {
                    DispatchQueue.main.async {
                        self?.user = user
                    }
                    completion(nil)
                }
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
            self.userProfile = nil
        } catch {
            print("Error signing out: \(error)")
        }
    }
}
