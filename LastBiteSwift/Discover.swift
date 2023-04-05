import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let coordinate = CLLocationCoordinate2D(latitude: 37.33182, longitude: -122.03118)
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        uiView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        uiView.addAnnotation(annotation)
    }
}

struct CardView: View {
    var body: some View {
        VStack {
            Text("Card View")
                .font(.title)
            Text("This is a card.")
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .cornerRadius(16)
    }
}

struct Discover: View {
    @State private var searchText = ""
    @State private var showCard = false
    @State private var searchplaceholder = ""
    
    var body: some View {
        ZStack {
            VStack(spacing: 0){
                Text("Discover")
                    .font(.custom("DMSans-Bold", size: 20))
                    .foregroundColor(Color("AccentColor"))
                    .padding(.top)
                
//                IconTextField(icon: "magnifyingglass", text: $searchplaceholder)
//                    .padding()
            }
            
            MapView()
                .edgesIgnoringSafeArea(.all)

            if showCard {
                CardView()
                    .transition(.move(edge: .bottom))
            }
        }

    }
}

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField(placeholder, text: $text)
                .foregroundColor(.primary)
            
            if !text.isEmpty {
                Button(action: {
                    self.text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.vertical, 10)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}


struct Discover_Previews: PreviewProvider {
    static var previews: some View {
        Discover()
    }
}
