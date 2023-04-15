// OrdersCardView.swift
import SwiftUI

struct OrdersCardView: View {
    let order: OrdersModel

    var body: some View {
        VStack(alignment: .leading) {


            Text("Restaurant Id: \(order.restaurantId)")
                .font(.subheadline)

            Text("Date: \(formattedDate(from: order.timestamp))")
                .font(.subheadline)

            if order.status == "OPEN" || order.status == "PROPOSED" {
                Text("Status: \(order.status)")
                    .font(.subheadline)
                    .foregroundColor(.green)
            } else {
                Text("Status: \(order.status)")
                    .font(.subheadline)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .shadow(radius: 4)
    }

    private func formattedDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}

