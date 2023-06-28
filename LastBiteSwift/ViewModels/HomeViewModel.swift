

import Foundation

import FirebaseFirestore
import MapKit
import FirebaseFirestoreSwift
import FirebaseFunctions
import Combine
import Foundation

class HomeViewModel: ObservableObject {
    
    @Published var restaurants = [Restaurant]()
    
    private var userService = UserService()
    private var db = Firestore.firestore()
    
    
    func milesToMeters(miles: Double) async throws -> Double{
        return miles * 1609.34
    }
    
    
        
    func fetchData() async throws {
        
        let (location, radius) = try await userService.fetchUserLocation()
        
        let data: [String: Any] = [
            "latitude": location.latitude,
            "longitude": location.longitude,
            "radius": try await milesToMeters(miles: radius)
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
            let fetchedRestaurants = try JSONDecoder().decode([RestaurantResponse].self, from: data)
            DispatchQueue.main.async {
                self.restaurants = fetchedRestaurants.map { restaurantResponse in
                       // Create a Restaurant object from RestaurantResponse object
                    Restaurant(id: restaurantResponse.id,
                               name: restaurantResponse.name,
                               createdOn: Timestamp(date: restaurantResponse.createdOn.asDate),
                               rating: restaurantResponse.rating,
                               description: restaurantResponse.description,
                               price: restaurantResponse.price,
                               ordersLeft: restaurantResponse.ordersLeft,
                               distanceFromUser: restaurantResponse.distanceFromUser,
                               address: restaurantResponse.address,
                               type: restaurantResponse.type,
                               pointOfSaleInfo: restaurantResponse.pointOfSaleInfo.map { Restaurant.PoSInfo(system: $0.system, locationId: $0.locationId, restaurantExternalId: $0.restaurantExternalId) },
                               accessTokenInfo: restaurantResponse.accessTokenInfo.map { Restaurant.AccessTokenInfo(accessToken: $0.accessToken, expiresAt: Timestamp(date: $0.expiresAt.asDate), refreshToken: $0.refreshToken) },
                               merchantId: restaurantResponse.merchantId,
                               lat: restaurantResponse.lat, lng: restaurantResponse.lng)
                }
            }
        } catch {
            print("Error fetching nearby restaurants: \(error)")
            throw error
        }
    }


    
    func annotationsForVisibleRegion(region: MKCoordinateRegion) -> [Restaurant] {
        let buffer = 0.1 // Adjust the buffer value as per your needs
        let minLatitude = region.center.latitude - (region.span.latitudeDelta / 2) - buffer
        let maxLatitude = region.center.latitude + (region.span.latitudeDelta / 2) + buffer
        let minLongitude = region.center.longitude - (region.span.longitudeDelta / 2) - buffer
        let maxLongitude = region.center.longitude + (region.span.longitudeDelta / 2) + buffer

        return restaurants.filter { restaurant in
            let lat = restaurant.lat
            let lon = restaurant.lng
            return lat! >= minLatitude && lat! <= maxLatitude && lon! >= minLongitude && lon! <= maxLongitude
        }
    }


}
