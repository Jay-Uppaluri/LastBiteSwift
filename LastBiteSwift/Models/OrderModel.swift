import FirebaseFirestoreSwift
import Foundation

struct OrdersModel: Identifiable, Codable {
    @DocumentID var id: String?
    var paymentIntentId: String
    var restaurantId: String
    var active: Bool
    var timestamp: Date
    var userId: String
}

