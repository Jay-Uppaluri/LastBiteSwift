import SwiftUI
import Combine
import FirebaseFirestore

@MainActor
class OrderViewModel: ObservableObject {
    @Published var orders: [OrdersModel] = []
    @Published var openOrAcceptedOrder: OrdersModel?
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
    
    func findOpenOrAcceptedOrder(completion: @escaping (OrdersModel?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.db.collection("orders")
                .whereField("userId", isEqualTo: self.userId)
                .whereField("status", in: ["OPEN", "ACCEPTED"])
                .limit(to: 1)
                .getDocuments { querySnapshot, error in
                    if let error = error {
                        print("Error fetching open or accepted order: \(error)")
                        completion(nil)
                    } else {
                        let order = querySnapshot?.documents.compactMap { queryDocumentSnapshot -> OrdersModel? in
                            do {
                                return try queryDocumentSnapshot.data(as: OrdersModel.self)
                            } catch {
                                print("Error decoding OrdersModel: \(error)")
                                return nil
                            }
                        }.first
                        self.openOrAcceptedOrder = order;
                        //print(order)
                        completion(order)
                    }
                }
        }
    }





    deinit {
        listener?.remove()
    }
}
