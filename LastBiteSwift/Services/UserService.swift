//
//  UserService.swift
//  LastBiteSwift
//
//  Created by Jay Uppaluri on 3/12/23.
//

import Foundation
import Firebase
import FirebaseFirestore

class UserService: ObservableObject {
    @Published var favorites: [String] = []

    init() {
        fetchUserFavorites { fetchedFavorites in
            if let fetchedFavorites = fetchedFavorites {
                self.favorites = fetchedFavorites
            }
        }
    }
    
    static func addUserToFirestore(uid: String, name: String, email: String) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(uid)
        
        let userData: [String: Any] = [
            "name": name,
            "email": email,
            // Add any other user data here
        ]
        
        userRef.setData(userData) { error in
            if let error = error {
                print("Error adding user to Firestore: \(error.localizedDescription)")
            } else {
                print("User added to Firestore with ID: \(uid)")
            }
        }
    }
    
    func updateUserFavorites(restaurantId: String, isFavorite: Bool, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(AuthenticationManager.shared.getUserId()!)

        if isFavorite {
           // Add the restaurantId to the user's favorites list
           userRef.updateData([
               "favorites": FieldValue.arrayUnion([restaurantId])
           ]) { error in
               if let error = error {
                   print("Error adding restaurant to favorites: \(error.localizedDescription)")
                   completion(false)
               } else {
                   completion(true)
               }
           }
        } else {
           // Remove the restaurantId from the user's favorites list
           userRef.updateData([
               "favorites": FieldValue.arrayRemove([restaurantId])
           ]) { error in
               if let error = error {
                   print("Error removing restaurant from favorites: \(error.localizedDescription)")
                   completion(false)
               } else {
                   completion(true)
               }
           }
        }
    }
    
    func fetchUserFavorites(completion: @escaping ([String]?) -> Void) {
        guard let userId = AuthenticationManager.shared.getUserId() else {
            completion(nil)
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)
        
        userRef.getDocument { documentSnapshot, error in
            if let error = error {
                print("Error fetching user favorites: \(error.localizedDescription)")
                completion(nil)
            } else {
                let favorites = documentSnapshot?.data()?["favorites"] as? [String] ?? []
                completion(favorites)
            }
        }
    }

    
}



