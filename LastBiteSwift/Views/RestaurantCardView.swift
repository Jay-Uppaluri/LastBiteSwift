

import SwiftUI
import Foundation
import FirebaseFirestore

struct RestaurantCardView: View {
    var restaurant: Restaurant
    @Binding private var isHeartToggled: Bool
    var onHeartToggle: (() -> Void)? = nil
    @EnvironmentObject var userService: UserService
    
    
    init(restaurant: Restaurant, isHeartToggled: Binding<Bool>, onHeartToggle: (() -> Void)? = nil) {
        self.restaurant = restaurant
        _isHeartToggled = isHeartToggled
        self.onHeartToggle = onHeartToggle
    }

    
    var body: some View {
        NavigationLink(destination: RestaurantDetailView(restaurant: restaurant).navigationBarBackButtonHidden(true)) {
        VStack {
            VStack(spacing: 8) {
                Image("card-image")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 245, height: 140)
                    .cornerRadius(4)
                    .overlay(
                        HStack {
                            Spacer()
                            Button(action: {
                                 self.isHeartToggled.toggle()
                                 userService.updateUserFavorites(restaurantId: restaurant.id ?? "", isFavorite: isHeartToggled) { success in
                                     if success {
                                         print("User's favorites updated successfully.")
                                         onHeartToggle?()
                                     } else {
                                         print("Error updating user's favorites.")
                                         // You can also toggle the isHeartToggled back to the previous state if the operation fails
                                         isHeartToggled.toggle()
                                     }
                                 }
                             }) {
                                if isHeartToggled {
                                    Image("heart.fill.remix")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.red)
                                } else {
                                    Image("heart.line.remix")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .padding(),
                        alignment: .topTrailing
                    )
                
                HStack(){
                    VStack(spacing: 2){
                        HStack(){
                            Text(restaurant.name)
                                .font(.custom("DMSans-Bold", size: 16))
                            Spacer()
                        }
                        HStack(spacing: 6){
                            Text(String(restaurant.rating))
                                .font(.custom("DMSans-Regular", size: 13))
                            
                            Image(systemName: "star.fill")
                                .resizable()
                                .frame(width: 10.0, height: 10.0)
                    
                            
                            Text("∙")
                                .font(.custom("DMSans-Regular", size: 13))
                            
                            Text("5 miles")
                                .font(.custom("DMSans-Regular", size: 13))
                            Spacer()
                        }
                        .foregroundColor(.gray)
                        
                    }
                    Text("$\(String(format: "%.2f", restaurant.price))")
                        .font(.custom("DMSans-Bold", size: 16))
                        .frame(width: 68, height: 27)
                        .background(Color("AccentColor"))
                        .foregroundColor(.white)
                        .cornerRadius(4.0)
                    
                    
                }
            }
            .frame(width: 245, height: 188)
            .background(Color.white)
            .cornerRadius(4)
            .shadow(radius: 0)
        }
    }
    }
}

struct RestaurantCardView_Previews: PreviewProvider {static var previews: some View {
    RestaurantCardView(
        restaurant: Restaurant(
            name: "Restaurant 1",
            createdOn: Timestamp(),
            location: GeoPoint(latitude: 0, longitude: 0),
            ordersRemaining: 0,
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
        ),
        isHeartToggled: .constant(false)
    )
    .environmentObject(UserService())
}
}
