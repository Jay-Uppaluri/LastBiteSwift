//
//  UserService.swift
//  LastBiteSwift
//
//  Created by Jay Uppaluri on 3/12/23.
//

import Foundation
import Firebase
import FirebaseFirestore


class UserService {
    
    static func addUserToFirestore(name: String, email: String) {
        let db = Firestore.firestore()
        let userRef = db.collection("users")
        
        let userData: [String: Any] = [
            "name": name,
            "email": email,
            // Add any other user data here
        ]
        
        userRef.addDocument(data : userData) { error in
            if let error = error {
                print("Error adding user to Firestore: \(error.localizedDescription)")
            } else {
                print("User added to Firestore")
            }
        }
    }
    
}


