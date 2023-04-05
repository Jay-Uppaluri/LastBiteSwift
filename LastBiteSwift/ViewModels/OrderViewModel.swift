import SwiftUI
import Combine
import FirebaseFirestore

class OrderViewModel: ObservableObject {
    @Published var orders: [OrdersModel] = []

    private var db = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()

    init() {
        fetchData()
    }

    func fetchData() {
        db.collection("orders").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            self.orders = documents.map { (queryDocumentSnapshot) -> OrdersModel in
                let data = queryDocumentSnapshot.data()
                let id = data["id"] as? String ?? ""
                let paymentIntent = data["paymentIntent"] as? [String: Any] ?? [:]
                let restaurantId = data["restaurantId"] as? String ?? ""
                let active = data["active"] as? Bool ?? false
                let timestamp = data["timestamp"] as? Date ?? Date()
                let userId = data["userId"] as? String ?? ""

                return OrdersModel(id: id, paymentIntent: paymentIntent, restaurantId: restaurantId, active: active, timestamp: timestamp, userId: userId)
            }
        }
    }
}
