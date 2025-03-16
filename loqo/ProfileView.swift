import SwiftUI
import PhotosUI
import UIKit

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data?
    @State private var showSaveAlert = false
    @State private var showLogoutAlert = false  // ✅ State for logout confirmation

    var body: some View {
        VStack(spacing: 20) {
            // Profile Picture Picker
            PhotosPicker(selection: $selectedItem, matching: .images) {
                if let selectedImageData, let image = ImageFromData(selectedImageData) {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.blue, lineWidth: 3))
                        .shadow(radius: 5)
                } else {
                    Image(systemName: "person.crop.circle.fill") // Default profile icon
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.blue, lineWidth: 3))
                        .shadow(radius: 5)
                }
            }
            .onChange(of: selectedItem) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        selectedImageData = data
                    }
                }
            }

            // First Name TextField
            VStack(alignment: .leading) {
                Text("First Name")
                    .font(.headline)
                TextField("Enter your first name", text: Binding(
                    get: { authViewModel.userProfile?.firstName ?? "" },
                    set: { authViewModel.userProfile?.firstName = $0 }
                ))
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
            .padding(.horizontal, 16)

            // Last Name TextField
            VStack(alignment: .leading) {
                Text("Last Name")
                    .font(.headline)
                TextField("Enter your last name", text: Binding(
                    get: { authViewModel.userProfile?.lastName ?? "" },
                    set: { authViewModel.userProfile?.lastName = $0 }
                ))
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
            .padding(.horizontal, 16)

            // Phone Number TextField
            VStack(alignment: .leading) {
                Text("Phone Number")
                    .font(.headline)
                TextField("Enter your phone number", text: Binding(
                    get: { authViewModel.userProfile?.phoneNumber ?? "" },
                    set: { authViewModel.userProfile?.phoneNumber = $0 }
                ))
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
            .padding(.horizontal, 16)

            // Email TextField
            VStack(alignment: .leading) {
                Text("Email")
                    .font(.headline)
                TextField("Enter your email", text: Binding(
                    get: { authViewModel.userProfile?.email ?? "" },
                    set: { authViewModel.userProfile?.email = $0 }
                ))
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
            .padding(.horizontal, 16)

            Button(action: {
                authViewModel.updateUserProfile { success in
                    if success {
                        showSaveAlert = true
                    } else {
                        // Handle failure (e.g., show an error message)
                    }
                }
            }) {
                Text("Save Changes")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.horizontal, 16)
            }
            .alert(isPresented: $showSaveAlert) {
                Alert(title: Text("Success"), message: Text("Your profile has been updated!"), dismissButton: .default(Text("OK")))
            }


            // Logout Button with Confirmation Alert
            Button(action: {
                showLogoutAlert = true  // ✅ Show confirmation alert
            }) {
                Text("Log Out")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.horizontal, 16)
            }
            .alert(isPresented: $showLogoutAlert) {
                Alert(
                    title: Text("Confirm Logout"),
                    message: Text("Are you sure you want to log out?"),
                    primaryButton: .destructive(Text("Log Out")) {
                        authViewModel.signOut()
                    },
                    secondaryButton: .cancel()
                )
            }

            Spacer()
        }
        .navigationTitle("Profile")
        .onAppear {
            if let user = authViewModel.user {
                authViewModel.fetchUserProfile(uid: user.uid)
            }
        }
    }

    // Convert Data to SwiftUI Image
    func ImageFromData(_ data: Data) -> Image? {
        if let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        }
        return nil
    }
}

// MARK: - Preview
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView().environmentObject(AuthViewModel())
    }
}
