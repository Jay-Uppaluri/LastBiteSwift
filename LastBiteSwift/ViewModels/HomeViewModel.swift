

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
                let rating = data["Rating"] as! NSNumber
                let description = data["description"] as? String ?? ""
                let price = data["price"] as! NSNumber
                let address = data["address"] as? String ?? ""
                let type = data["type"] as? String ?? ""
                return Restaurant(id: queryDocumentSnapshot.documentID, name: name, createdOn: createdOn, location: location,
                                  ordersRemaining: ordersRemaining, rating: Float(truncating: rating), description: description, price: Float(truncating: price), ordersLeft: 3, address: address, type: type)
            }
        }
    }
}
