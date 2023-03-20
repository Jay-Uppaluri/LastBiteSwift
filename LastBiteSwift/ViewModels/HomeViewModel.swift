

import Foundation

import FirebaseFirestore
import MapKit

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
                return Restaurant(name: name, createdOn: createdOn, location: location,
                                  ordersRemaining: ordersRemaining, rating: Float(truncating: rating), description: description, price: Float(truncating: price), ordersLeft: 3, address: address, type: type)
            }
        }
    }
    
    func annotationsForVisibleRegion(region: MKCoordinateRegion) -> [Restaurant] {
        let minLatitude = region.center.latitude - region.span.latitudeDelta / 2
        let maxLatitude = region.center.latitude + region.span.latitudeDelta / 2
        let minLongitude = region.center.longitude - region.span.longitudeDelta / 2
        let maxLongitude = region.center.longitude + region.span.longitudeDelta / 2

        return restaurants.filter { restaurant in
            let lat = restaurant.location.latitude
            let lon = restaurant.location.longitude
            return lat >= minLatitude && lat <= maxLatitude && lon >= minLongitude && lon <= maxLongitude
        }
    }

}
