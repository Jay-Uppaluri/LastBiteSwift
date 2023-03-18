//
//  DiscoverMap.swift
//  LastBiteSwift
//
//  Created by Jay Uppaluri on 3/18/23.
//

import SwiftUI
import FirebaseFirestore
import Foundation
import MapKit

struct ContentView: View {
    @StateObject var viewModel = HomeViewModel()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    var body: some View {
        NavigationView {
            Map(coordinateRegion: $region, annotationItems: viewModel.restaurants) { restaurant in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: restaurant.location.latitude, longitude: restaurant.location.longitude)) {
                    MarkerView(restaurant: restaurant)
                }
            }
            .onAppear(perform: viewModel.fetchData)
            .edgesIgnoringSafeArea(.top)
        }
    }
}

struct MarkerView: View {
    let restaurant: Restaurant
    @State private var isActive = false

    var body: some View {
        VStack {
            NavigationLink(destination: RestaurantView(restaurant: restaurant), isActive: $isActive) {
                EmptyView()
            }
            Button(action: {
                isActive = true
            }) {
                Image(systemName: "mappin.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30, alignment: .center)
                    .foregroundColor(.red)
            }
        }
    }
}

