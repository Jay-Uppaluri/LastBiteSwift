import FirebaseFirestoreSwift
import Foundation

struct OrdersModel: Identifiable, Codable {
    @DocumentID var id: String?
    var paymentIntentId: String
    var restaurantId: String
    var status: String
    var timestamp: Date
    var userId: String
    var amount: Int
}

