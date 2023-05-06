import SwiftUI
import Combine
import Firebase
import MapKit
import FirebaseFirestore
import FirebaseFirestoreSwift

struct RestaurantDetailView: View {
    let restaurant: Restaurant
    var categories = ["Sandwiches", "Pastries", "Salads"]
    @Environment(\.presentationMode) var presentationMode
    @State private var isFavorite: Bool = false
    @ObservedObject var userService = UserService()
    @State private var showPaymentPopUp: Bool = false


    init(restaurant: Restaurant) {
        self.restaurant = restaurant

    }

    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    // background
                    ZStack {
                        Image("lastbiteplaceholderimage")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.screenWidth, height: 160)

                        VStack {
                            Spacer()

                            Image("restLogo")
                                .resizable()
                                .frame(width: 64, height: 64)
                                .background(.white)
                                .clipShape(Circle())
                                .shadow(color: .gray, radius: 5, x: 0, y: 1)
                                .padding(.top, 222)
                        }
                    }
                    .frame(height: 224)
                    .padding(.bottom, 22)

                    Text(restaurant.name)
                        .font(.custom("DMSans-Bold", size: 32))
                        .padding(.bottom, 8)

                    HStack(spacing: 1) {
                        Text(restaurant.type)
                        Text(" ∙ ")
                        Text(String(format: "%.1f", restaurant.rating))
                        Text("★")
                            .font(.custom("DMSans-Medium", size: 12))
                    }
                    .font(.custom("DMSans-Medium", size: 16))

                    VStack {
                        Text("\(restaurant.ordersLeft) packages left")
                            .frame(width: 96)
                            .font(.custom("DMSans-Bold", size: 12))
                            .padding()
                            .foregroundColor(Color(hex: "175C4E"))
                    }
                    .frame(height: 24)
                    .background(Color(hex: "84D5C1"))
                    .cornerRadius(37)

                    HStack {
                        Text("Pickup Today")
                            .foregroundColor(Color.accentColor)
                            .font(.custom("DMSans-Bold", size: 16))

                        Text("from 8AM to 10PM")
                            .font(.custom("DMSans-Regular", size: 16))
                    }
                    
                    Text(String(format: "%2.1f", restaurant.distanceFromUser ?? 0) +  " miles")
                        .font(.custom("DM-Sans-Bold", size: 16))

                    

                    VStack(alignment: .leading) {
                        Text("Location")
                            .font(.custom("DMSans-Bold", size: 16))

                        HStack {
                            Image("pinpoint")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                            Link(destination: createMapURL()) {
                                Text(restaurant.address)
                            }
                        }
                        .frame(height: 24)


                        Text("What you could get")
                            .font(.custom("DMSans-Bold", size: 16))
                            .padding(.top)

                        // loop categories
                        HStack(spacing: 11) {
                            ForEach(categories, id: \.self) { category in
                                CategoriesCard(category: category)
                            }
                        }

                        Text("About Us")
                            .padding(.top)
                            .font(.custom("DMSans-Bold", size: 16))
                            .padding(.bottom, 2)

                        Text(restaurant.description)
                            .multilineTextAlignment(.leading)


                    }
                    .padding(16)
                    .font(.custom("DMSans-Regular", size: 16))
                }
            }
            .onAppear {
                userService.fetchUserFavorites { fetchedFavorites in
                    if let fetchedFavorites = fetchedFavorites {
                        isFavorite = fetchedFavorites.contains(restaurant.id ?? "")
                    }
                }
            }
            .edgesIgnoringSafeArea(.top)

            // upper buttons
            VStack(alignment: .leading) {
                HStack(spacing: 10) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text(Image(systemName: "arrow.backward"))
                            .frame(width: 36, height: 36)
                            .font(Font.system(size: 17, weight: .bold, design: .default))
                            .foregroundColor(Color.black)
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                    .padding(.leading, 10)
                    .shadow(color: .gray, radius: 5, x: 0, y: 1)
                    Spacer()
                    Button(action: {
                        isFavorite.toggle()
                        userService.updateUserFavorites(restaurantId: restaurant.id!, isFavorite: isFavorite) { success in
                            if success {
                                if isFavorite {
                                    userService.favorites.append(restaurant.id!)
                                } else {
                                    userService.favorites.removeAll(where: { $0 == restaurant.id })
                                }
                            } else {
                                isFavorite.toggle() // Revert the favorite state if the operation failed
                            }
                        }
                    }) {
                        Image(isFavorite ? "heart.fill.remix" : "heart.line.remix")
                            .scaleEffect(1.3)
                            .frame(width: 36, height: 36)
                            .font(Font.system(size: 17, weight: .bold, design: .default))
                            .foregroundColor(Color.black)
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                    .shadow(color: .gray, radius: 5, x: 0, y: 1)

                    Button(action: {
                        print("Share")
                    }) {
                        Text(Image(systemName: "square.and.arrow.up"))
                            .frame(width: 36, height: 36)
                            .font(Font.system(size: 17, weight: .bold, design: .default))
                            .foregroundColor(Color.black)
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                    .padding(.trailing, 10)
                    .shadow(color: .gray, radius: 5, x: 0, y: 1)
                }
                .frame(alignment: .leading)
                Spacer()
            }
        }
        
        Divider()
            .frame(height: 1)
            .background(Color(red: 0.85, green: 0.85, blue: 0.85))
            .edgesIgnoringSafeArea([.horizontal])
        if (!showPaymentPopUp) {
            Button(action: {
                print("reserve tapped")
                showPaymentPopUp.toggle()

            }) {
                Text("Reserve")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .font(.custom("DMSans-Medium", size: 18))
                    .padding()
                    .foregroundColor(.white)
            }
            
            .frame(height: 51)
            .background(Color.accentColor)
            .cornerRadius(37)
            .padding(.bottom, 24)
            .padding(.top, 24)
            .padding(.horizontal, 24)
        }

        if showPaymentPopUp {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    showPaymentPopUp = false
                }
            
            PaymentPopUpView()
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
                .animation(.easeInOut)
        }
    }
    func createMapURL() -> URL {
        let latitude = restaurant.location.latitude
        let longitude = restaurant.location.longitude
        let addressEncoded = urlEncodedAddress(restaurant.address)
        let url = URL(string: "https://www.google.com/maps?q=\(addressEncoded)&ll=\(latitude),\(longitude)")!
        return url
    }

    
    func urlEncodedAddress(_ address: String) -> String {
        let allowedCharacters = CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted
        return address.addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? ""
    }


    
}



struct RestaurantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantDetailView(
            restaurant: Restaurant(
                name: "Restaurant 1",
                createdOn: Timestamp(),
                location: GeoPoint(latitude: 0, longitude: 0),
                rating: 4.9,
                description: "A great restaurant",
                price: 3.98,
                ordersLeft: 3,
                address: "421 East Falls Lane",
                type: "Healthy",
                pointOfSaleInfo: Restaurant.PoSInfo(
                    system: "square",
                    locationId: "TEST_SQUARE_LOCATION_ID",
                    restaurantExternalId: nil
                ),
                accessTokenInfo: Restaurant.AccessTokenInfo(accessToken: "test", expiresAt: Timestamp(), refreshToken: "test"), merchantId: "test"
            )
        )
    }
}

