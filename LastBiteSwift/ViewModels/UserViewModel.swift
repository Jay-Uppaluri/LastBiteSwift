import Foundation
import FirebaseFirestore



class UserViewModel: ObservableObject {
    @Published var users = [User]()
    private var db = Firestore.firestore()

    func fetchData() {
        db.collection("users").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            self.users = documents.map { (queryDocumentSnapshot) -> User in
                let data = queryDocumentSnapshot.data()
                let name = data["name"] as? String ?? ""
                let phoneNumber = data["phone"] as? String ?? ""
                let createdOn = data["CreatedOn"] as! Timestamp
                let ordersPlaced = data["ordersPlaced"] as! Int
                let location = data["location"] as! GeoPoint

                return User(id: queryDocumentSnapshot.documentID, name: name,createdOn: createdOn, phoneNumber: phoneNumber,
                            ordersPlaced: ordersPlaced, location: location)

            }
        }
    }
}
