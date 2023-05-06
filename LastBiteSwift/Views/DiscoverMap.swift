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

extension MKCoordinateRegion: Equatable {
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        return lhs.center.latitude == rhs.center.latitude &&
            lhs.center.longitude == rhs.center.longitude &&
            lhs.span.latitudeDelta == rhs.span.latitudeDelta &&
            lhs.span.longitudeDelta == rhs.span.longitudeDelta
    }
}

struct ContentView: View {
    @StateObject var viewModel = HomeViewModel()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    var body: some View {
        NavigationView {
            Map(coordinateRegion: $region, annotationItems: viewModel.annotationsForVisibleRegion(region: region)) { restaurant in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: restaurant.location.latitude, longitude: restaurant.location.longitude)) {
                    MarkerView(restaurant: restaurant)
                }
            }
            .onAppear {
                Task {
                    do {
                        try await viewModel.fetchData()
                    } catch {
                        print("Error fetching data: \(error)")
                    }
                }
            }
            .edgesIgnoringSafeArea(.top)
            .onChange(of: region) { newRegion in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    Task {
                        do {
                            try await viewModel.fetchData()
                        } catch {
                            print("Error fetching data: \(error)")
                        }
                    }
                }
            }
        }
    }
}




struct MarkerView: View {
    let restaurant: Restaurant
    @State private var isActive = false

    var body: some View {
        VStack {
            NavigationLink(destination: RestaurantDetailView(restaurant: restaurant), isActive: $isActive) {
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

