import Combine
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct RestaurantViewModel: Identifiable, Codable {
    var id: String?
    let name: String
    let createdOn: Date
    let location: GeoPoint
    let rating: Float
    let description: String
    let price: Float
    let ordersLeft: Int
    var distanceFromUser: Double?
    let address: String
    let type: String
    let pointOfSaleInfo: PoSInfo?
    let accessTokenInfo: AccessTokenInfo?
    let merchantId: String

    struct PoSInfo: Codable {
        let system: String
        let locationId: String?
        let restaurantExternalId: String?
    }

    struct AccessTokenInfo: Codable {
        let accessToken: String
        let expiresAt: Date
        let refreshToken: String
    }

    enum CodingKeys: String, CodingKey {
        case id, name, createdOn, location, rating, description, price, ordersLeft, distanceFromUser, address, type, pointOfSaleInfo, accessTokenInfo, merchantId
    }


}
