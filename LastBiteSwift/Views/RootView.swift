import SwiftUI
import FirebaseAuth

struct RootView: View {
    @State private var firebaseUser: FirebaseAuth.User?
    @State private var isLoggedIn = false // Add a new state variable

    var body: some View {
        NavigationView { // Wrap the Group with a NavigationView
            Group {
                if isLoggedIn { // Use the new state variable to check the authentication state
                    FavoritesPage()
                } else {
                    LandingPage()
                }
            }
            .onAppear(perform: configureAuthListener)
            .navigationBarHidden(true) // Hide the navigation bar
        }
    }

    private func configureAuthListener() {
        Auth.auth().addStateDidChangeListener { auth, user in
            self.firebaseUser = user
            self.isLoggedIn = AuthenticationManager.shared.isUserLoggedIn() // Update the new state variable
        }
    }

    private func signOut() {
        AuthenticationManager.shared.signOut()
        self.isLoggedIn = false // Update the new state variable when the user logs out
    }
}

