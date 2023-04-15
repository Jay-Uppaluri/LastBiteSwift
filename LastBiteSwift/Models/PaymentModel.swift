
import Foundation


struct Payment: Encodable {
    let amount: Int
    let userId: String
    let restaurantId : String
    let orderType: String
}

