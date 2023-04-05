// OrdersCardView.swift
import SwiftUI

struct OrdersCardView: View {
    let order: OrdersModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("Order ID: \(order.id)")
                .font(.headline)
                .foregroundColor(Color("AccentColor"))

            Text("Restaurant ID: \(order.restaurantId)")
                .font(.subheadline)

            Text("Date: \(order.timestamp, formatter: DateFormatter.localizedDateFormatter)")
                .font(.subheadline)

            if order.active {
                Text("Status: Active")
                    .font(.subheadline)
                    .foregroundColor(.green)
            } else {
                Text("Status: Inactive")
                    .font(.subheadline)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .shadow(radius: 4)
    }
}

extension DateFormatter {
    static let localizedDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
}
