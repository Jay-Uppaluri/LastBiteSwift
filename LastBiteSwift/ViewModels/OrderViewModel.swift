import SwiftUI
import Combine
import FirebaseFirestore

@MainActor
class OrderViewModel: ObservableObject {
    @Published var orders: [OrdersModel] = []
    @Published var openOrAcceptedOrder: OrdersModel?
    private var db = Firestore.firestore()
    private var userId: String
    
    var orderListener: ListenerRegistration?


    init(userId: String) {
        self.userId = userId
    }

    
    func startListeningForOpenOrAcceptedOrder() {
        self.orderListener = db.collection("orders")
            .whereField("userId", isEqualTo: self.userId)
            .whereField("status", in: ["OPEN", "ACCEPTED"])
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching open or accepted order")
                    return
                }
                self.openOrAcceptedOrder = documents.compactMap { queryDocumentSnapshot -> OrdersModel? in
                    try? queryDocumentSnapshot.data(as: OrdersModel.self)
                }.first
            }
    }

    // Add this method to stop listening
    func stopListeningForOpenOrAcceptedOrder() {
        self.orderListener?.remove()
        self.orderListener = nil
    }

    
    func findOpenOrAcceptedOrder(completion: @escaping (OrdersModel?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
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

}
