import SwiftUI
import Combine
import FirebaseFirestore

@MainActor
class OrderViewModel: ObservableObject {
    @Published var orders: [OrdersModel] = []

    private var db = Firestore.firestore()
    private var userId: String // assuming you have the current user's ID available
    private var listener: ListenerRegistration?

    init(userId: String) {
        self.userId = userId
        listenForOrderUpdates()
    }

    func listenForOrderUpdates() {
        listener = db.collection("orders")
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching order updates: \(error!)")
                    return
                }

                self.orders = documents.compactMap { queryDocumentSnapshot -> OrdersModel? in
                    return try? queryDocumentSnapshot.data(as: OrdersModel.self)
                }
            }
    }

    deinit {
        listener?.remove()
    }
}
