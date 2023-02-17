//
//  HomeViewModel.swift
//  LastBiteSwift
//
//  Created by Jay Uppaluri on 2/17/23.
//

import Foundation

import FirebaseFirestore

class HomeViewModel: ObservableObject {
    
    @Published var restaurants = [Restaurant]()
    
    private var db = Firestore.firestore()
    
    func fetchData() {
        db.collection("restaurants").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            
            self.restaurants = documents.map { (queryDocumentSnapshot) -> Restaurant in
                let data = queryDocumentSnapshot.data()
                let name = data["Name"] as? String ?? ""
                let createdOn = data["CreatedOn"] as! Timestamp
                let location = data["Location"] as! GeoPoint
                let ordersRemaining = data["OrdersRemaining"] as! Int
                let rating = data["Rating"] as? Float ?? -1.00
                let description = data["description"] as? String ?? ""
                return Restaurant(id: queryDocumentSnapshot.documentID, name: name, createdOn: createdOn, location: location,
                                  ordersRemaining: ordersRemaining, rating: rating, description: description)
            }
            print(self.restaurants)
        }
    }
}
