// OrdersModel.swift
import Foundation

struct OrdersModel: Identifiable {
    var id: String
    var paymentIntent: [String: Any]
    var restaurantId: String
    var active: Bool
    var timestamp: Date
    var userId: String
}

