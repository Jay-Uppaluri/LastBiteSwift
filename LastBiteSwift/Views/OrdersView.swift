import SwiftUI

struct OrdersView: View {
    @StateObject private var viewModel = OrderViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Active Orders")
                    .font(.title)
                    .bold()

                ForEach(viewModel.orders.filter { $0.active }) { order in
                    OrdersCardView(order: order)
                        .padding(.bottom, 8)
                }

                Text("Your History")
                    .font(.title)
                    .bold()

                ForEach(viewModel.orders.filter { !$0.active }) { order in
                    OrdersCardView(order: order)
                        .padding(.bottom, 8)
                }
            }
            .padding()
        }
        .navigationTitle("Orders")
    }
}

