

import Foundation

import FirebaseFirestore
import MapKit

class HomeViewModel: ObservableObject {
    
    @Published var restaurants = [Restaurant]()
    
    private var db = Firestore.firestore()
    
        
    func fetchData() async throws {
        let fetchedRestaurants = try await db.collection("restaurants").getDocuments().documents.compactMap { document in
            try document.data(as: Restaurant.self)
        }
        
        DispatchQueue.main.async {
            self.restaurants = fetchedRestaurants
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
