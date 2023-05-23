import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let geocoder = CLGeocoder()
    private let manager = CLLocationManager()
    @Published var location: CLLocation?
    @Published var searchResults: [String] = []
    private var searchCancellable: AnyCancellable?
    private let searchSubject = PassthroughSubject<String, Never>()
    @Published var selectedLocation: CLLocationCoordinate2D?

    
    override init() {
        super.init()
        manager.delegate = self
        searchCancellable = searchSubject
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] in self?.performSearch(address: $0) }
    }

    func requestLocation() {
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }

    func search(address: String) {
        searchSubject.send(address)
    }

    private func performSearch(address: String) {
        geocoder.geocodeAddressString(address) { placemarks, error in
            guard let placemarks = placemarks, error == nil else {
                // Handle error here
                return
            }
            self.searchResults = placemarks.compactMap { placemark in
                guard let name = placemark.name,
                      let locality = placemark.locality,
                      let administrativeArea = placemark.administrativeArea else { return nil }
                return "\(name), \(locality), \(administrativeArea)"
            }
            // Set selected location
            if let firstPlacemark = placemarks.first,
               let location = firstPlacemark.location {
                self.selectedLocation = location.coordinate
            }
        }
    }

}
