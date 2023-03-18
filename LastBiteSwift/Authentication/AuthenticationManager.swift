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
    
    func isEmailVerified(completion: @escaping (Bool) -> Void) {
        user?.reload(completion: { error in
            if let error = error {
                print("Error reloading user: \(error.localizedDescription)")
                completion(false)
            } else {
                let isVerified = self.user?.isEmailVerified ?? false
                completion(isVerified)
            }
        })
    }
}
