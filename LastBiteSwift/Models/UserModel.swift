import Foundation
import FirebaseFirestore

struct User: Identifiable {

    var id: String = UUID().uuidString
    let name: String
    let createdOn: Timestamp
    let phoneNumber: String
    let ordersPlaced: Int

    //maybe the user also notifications boolean on or off
    //maybe users also has whether or not they get emails sent to them
}
