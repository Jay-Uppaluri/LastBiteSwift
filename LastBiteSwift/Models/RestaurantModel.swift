

import Foundation

import FirebaseFirestore


struct Restaurant: Identifiable {
    var id: String = UUID().uuidString
    let name: String
    let createdOn: Timestamp
    let location: GeoPoint
    let ordersRemaining: Int
    let rating: Float
    let description: String
}
