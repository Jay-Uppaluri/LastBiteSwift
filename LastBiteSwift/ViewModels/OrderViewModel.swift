import SwiftUI
import Combine
import FirebaseFirestore

@MainActor
class OrderViewModel: ObservableObject {
    @Published var orders: [OrdersModel] = []

    private var db = Firestore.firestore()
    private var userId: String // assuming you have the current user's ID available

    init(userId: String) {
        self.userId = userId
        Task {
            do {
                try await fetchData()
            } catch {
                print("Error fetching orders: \(error)")
            }
        }
    }

    func fetchData() async throws {
        let fetchedOrders = try await db.collection("orders").whereField("userId", isEqualTo: userId).getDocuments().documents.compactMap { document in
            try document.data(as: OrdersModel.self)
        }

        self.orders = fetchedOrders
    }
}
