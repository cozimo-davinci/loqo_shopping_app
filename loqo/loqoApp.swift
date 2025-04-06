import SwiftUI
import Firebase

// Firebase configuration via AppDelegate
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct loqoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var dataController = DataController()
    @StateObject private var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView(path: .constant(NavigationPath()))
                .environment(\.managedObjectContext, dataController.persistentContainer.viewContext)
                .environmentObject(authViewModel)
                .environmentObject(dataController) // Optional but useful if you need the controller itself
        }
    }
}
