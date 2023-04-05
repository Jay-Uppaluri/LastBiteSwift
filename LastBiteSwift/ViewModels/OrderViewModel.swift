import SwiftUI
import Combine
import FirebaseFirestore

@MainActor
class OrderViewModel: ObservableObject {
    @Published var orders: [OrdersModel] = []

    private var db = Firestore.firestore()

    init() {
        Task {
            do {
                try await fetchData()
            } catch {
                print("Error fetching orders: \(error)")
            }
        }
    }

    func fetchData() async throws {
        let fetchedOrders = try await db.collection("orders").getDocuments().documents.compactMap { document in
            try document.data(as: OrdersModel.self)
        }

        self.orders = fetchedOrders
    }
}

