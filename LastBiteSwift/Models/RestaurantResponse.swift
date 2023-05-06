//
//  RestaurantResponse.swift
//  LastBiteSwift
//
//  Created by Jay Uppaluri on 5/6/23.
//

import Foundation


import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct RestaurantResponse: Identifiable, Codable {
    var id: String?
    let name: String
    let createdOn: TimestampContainer
    let location: GeoPoint
    let rating: Float
    let description: String
    let price: Float
    let ordersLeft: Int
    var distanceFromUser: Double?
    let address: String
    let type: String
    let pointOfSaleInfo: PoSInfo?
    let accessTokenInfo: AccessTokenInfo?
    let merchantId: String
    

    
    struct PoSInfo: Codable {
        let system: String
        let locationId: String?
        let restaurantExternalId: String?
    }
    
    struct AccessTokenInfo: Codable {
        let accessToken: String
        let expiresAt: TimestampContainer
        let refreshToken: String
    }
    
    struct TimestampContainer: Codable {
        let _seconds: Double
        let _nanoseconds: Int

        var asDate: Date {
            return Timestamp(seconds: Int64(_seconds), nanoseconds: Int32(_nanoseconds)).dateValue()
        }
    }
}


