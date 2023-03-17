
// This class is a Singleton, meaning there is only one instance of it

import Foundation

import FirebaseAuth

class AuthenticationManager {
    static let shared = AuthenticationManager()
    
    private var user: FirebaseAuth.User?
    
    private init() {
        user = Auth.auth().currentUser
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            self?.user = user
        }
    }
    
    func getUserId() -> String? {
        return user?.uid
    }
    
    func isUserLoggedIn() -> Bool {
        return user != nil
    }
}

