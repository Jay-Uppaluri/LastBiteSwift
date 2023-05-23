import SwiftUI
import MapKit
import Combine
import Foundation

struct MapMarkerOverlay: View {
    var body: some View {
        Image(systemName: "mappin.circle.fill")
            .resizable()
            .scaledToFit()
            .frame(height: 30) // Adjust the size here
            .offset(x: 0, y: -30) // Adjust offset if needed
    }
}

class Coordinator: NSObject, MKMapViewDelegate {
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var regionSpan: MKCoordinateSpan

    init(centerCoordinate: Binding<CLLocationCoordinate2D>, regionSpan: Binding<MKCoordinateSpan>) {
        _centerCoordinate = centerCoordinate
        _regionSpan = regionSpan
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        centerCoordinate = mapView.centerCoordinate
        regionSpan = mapView.region.span
    }
}

struct CustomMapView: UIViewRepresentable {
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var regionSpan: MKCoordinateSpan

    func makeCoordinator() -> Coordinator {
        Coordinator(centerCoordinate: $centerCoordinate, regionSpan: $regionSpan)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        let region = MKCoordinateRegion(center: centerCoordinate, span: regionSpan)
        view.setRegion(region, animated: true)
    }
}


struct ChangeAddressSubView: View {
    @State private var centerCoordinate = CLLocationCoordinate2D(latitude: 44.9778, longitude: -93.2650) // Default to Minneapolis, MN
    @State private var regionSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1) // Default zoom level
    @State private var address: String = ""
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ZStack {
                CustomMapView(centerCoordinate: $centerCoordinate, regionSpan: $regionSpan)
                    .frame(height: 300)
                MapMarkerOverlay()
            }
            
            HStack(spacing: 9){
                Spacer()
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .opacity(0.30)
                    .frame(width: 17, height: 17)
                TextField("Enter your Address", text: $address, onCommit: {
                    locationManager.search(address: address)
                })
                .keyboardType(.default)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .font(.custom(boldCustomFontName, size: 16))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .frame(width: 153)
                Spacer()
            }
            .padding(15)
            .background(Color("F4F4F6"))
            .cornerRadius(8)
            .onChange(of: locationManager.selectedLocation) { newLocation in
                if let newLocation = newLocation, newLocation != centerCoordinate {
                    centerCoordinate = newLocation
                    regionSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                }
            }


            Button {
                //MARK: APPLY BUTTON ACTION
                print(centerCoordinate)
            } label: {
                HStack{
                    Spacer()
                    Text("Apply")
                        .font(.custom(boldCustomFontName, size: 16))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
                .background(Color("FF5A60"))
                .cornerRadius(UIScreen.main.bounds.width * 0.20)
                .buttonStyle(.plain)
                .padding(EdgeInsets(top: 31, leading: 0, bottom: 15, trailing: 0))
            }.buttonStyle(.plain)

            Button {
                locationManager.requestLocation()
                    if let location = locationManager.location {
                    centerCoordinate = location.coordinate
                    regionSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                }
            } label: {
                HStack(alignment: .center, spacing: 8){
                    Image("location-sprite")
                        .resizable()
                        .frame(width: 14, height: 14)
                    Text("Use my current location")
                        .font(.custom(boldCustomFontName, size: 16))
                        .foregroundColor(Color("FF5A60"))
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 31, trailing: 0))
            }.buttonStyle(.plain)
        }
        .padding(16)
        .background(colorScheme == .dark ? .black : .white)
        .cornerRadius(8)
    }
}

struct ChangeAddressSubView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeAddressSubView()
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}


