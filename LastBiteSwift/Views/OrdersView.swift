import SwiftUI

struct OrdersView: View {
    let userId = AuthenticationManager.shared.getUserId()
    @StateObject private var viewModel: OrderViewModel

    init() {
        let userId = AuthenticationManager.shared.getUserId() ?? ""
        _viewModel = StateObject(wrappedValue: OrderViewModel(userId: userId))
    }
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Active Orders")
                    .font(.title)
                    .bold()

                ForEach(viewModel.orders.filter { $0.status == "OPEN" || $0.status == "PROPOSED" }.sorted(by: { $0.timestamp > $1.timestamp })) { order in
                    OrdersCardView(order: order)
                        .padding(.bottom, 8)
                }

                Text("Your History")
                    .font(.title)
                    .bold()

                ForEach(viewModel.orders.filter { $0.status == "CANCELLED" }.sorted(by: { $0.timestamp > $1.timestamp })) { order in
                    OrdersCardView(order: order)
                        .padding(.bottom, 8)
                }
            }
            .padding()
        }
        .navigationTitle("Orders")
    }
}

