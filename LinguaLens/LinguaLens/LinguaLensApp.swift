import SwiftUI
import Firebase

@main
struct LinguaLensApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            WelcomeView()
        }
    }
}
