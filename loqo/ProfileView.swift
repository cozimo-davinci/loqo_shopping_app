import SwiftUI
import PhotosUI // ✅ Built-in SwiftUI framework for picking images
import UIKit
struct ProfileView: View {
    @State private var name: String = "John Doe"
    @State private var phoneNumber: String = "+1 234 567 890"
    @State private var email: String = "johndoe@example.com"

    @State private var profileImage: Image? = Image(systemName: "person.crop.circle.fill") // Default profile icon
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data?
    @State private var showSaveAlert = false

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
                    profileImage?
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

            // Name TextField
            VStack(alignment: .leading) {
                Text("Name")
                    .font(.headline)
                TextField("Enter your name", text: $name)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
            .padding(.horizontal, 16)

            // Phone Number TextField
            VStack(alignment: .leading) {
                Text("Phone Number")
                    .font(.headline)
                TextField("Enter your phone number", text: $phoneNumber)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
            .padding(.horizontal, 16)

            // Email TextField
            VStack(alignment: .leading) {
                Text("Email")
                    .font(.headline)
                TextField("Enter your email", text: $email)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
            .padding(.horizontal, 16)

            // Save Changes Button
            Button(action: {
                showSaveAlert = true
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

            Spacer()
        }
        .navigationTitle("Profile")
    }

    // Convert Data to SwiftUI Image (Alternative to UIImage)
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
        ProfileView()
    }
}
