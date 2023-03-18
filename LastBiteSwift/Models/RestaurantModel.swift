

import Foundation

import FirebaseFirestore
import FirebaseFirestoreSwift

struct Restaurant: Identifiable, Codable {
    @DocumentID var id: String?
    let name: String
    let createdOn: Timestamp
    let location: GeoPoint
    let ordersRemaining: Int
    let rating: Float
    let description: String
    let price: Float
    let ordersLeft: Int
    var distanceFromUser: Double?
}

