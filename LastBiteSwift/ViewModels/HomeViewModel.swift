

import Foundation

import FirebaseFirestore
import MapKit
import FirebaseFirestoreSwift
import FirebaseFunctions

class HomeViewModel: ObservableObject {
    
    @Published var restaurants = [Restaurant]()
    
    private var db = Firestore.firestore()
    
        
    func fetchData() async throws {
        let data: [String: Any] = [
            "latitude": 42.000,
            "longitude": -42.000,
            "radius": 5
        ]
        
        if !AuthenticationManager.shared.isUserLoggedIn() {
            print("User not signed in")
            return
        }
        
        do {
            let idToken = try await AuthenticationManager.shared.getIDToken()
            let url = URL(string: "https://us-central1-lastbite-907b1.cloudfunctions.net/getNearbyRestaurants")!
            var request = URLRequest(url: url)
            request.setValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: data, options: [])
            
            let (data, _) = try await URLSession.shared.data(for: request)
            let fetchedRestaurants = try JSONDecoder().decode([Restaurant].self, from: data)
            DispatchQueue.main.async {
                self.restaurants = fetchedRestaurants
            }
        } catch {
            print("Error fetching nearby restaurants: \(error)")
            throw error
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
