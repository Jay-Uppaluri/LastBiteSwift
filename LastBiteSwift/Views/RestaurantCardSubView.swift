import SwiftUI
import FirebaseFirestore

struct RestaurantCardSubView: View {
    var imageWidth: Double = 358.0
    var imageHeight: Double = 140.0

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
            VStack(alignment: .leading, spacing: 8) {
                
                //MARK: IMAGE
                ZStack(alignment: .topTrailing) {
                    Image("lastbiteplaceholderimage")
                        .resizable()
                        .scaledToFill()
                        .frame(width: imageWidth, height: imageHeight)
                        .clipped()
                        .cornerRadius(4)
                    
                    VStack(alignment: .trailing) {
                        Button(action: {
                            self.isHeartToggled.toggle()
                            userService.updateUserFavorites(restaurantId: restaurant.id ?? "", isFavorite: isHeartToggled) { success in
                                if success {
                                    print("User's favorites updated successfully.")
                                    onHeartToggle?()
                                } else {
                                    print("Error updating user's favorites.")
                                    isHeartToggled.toggle()
                                }
                            }
                        }) {
                            if isHeartToggled {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.red)
                                    .padding(15)
                            } else {
                                Image(systemName: "heart")
                                    .foregroundColor(.red)
                                    .padding(15)
                            }
                        }
                        Spacer()
                        Text("5+ left")
                            .font(.custom(boldCustomFontName, size: 13))
                            .padding(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
                            .foregroundColor(Color("1B5346"))
                            .background(Color("84D6C2"))
                            .cornerRadius(20)
                            .padding(12)
                    }
                }
                .frame(width: imageWidth, height: imageHeight)
                
                //MARK: DETAILS
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(restaurant.name)
                            .font(.custom(boldCustomFontName, size: 16))
                            .lineLimit(1)
                        
                        HStack(spacing: 8) {
                            if true {
                                HStack(spacing: 2) {
                                    Image("new-star")
                                        .resizable()
                                        .frame(width: 11, height: 10)
                                    Text("New")
                                        .font(.custom(regularCustomFontName, size: 13))
                                }
                                Text("•")
                                    .font(.custom(regularCustomFontName, size: 13))
                                    .opacity(0.30)
                            }
                            Text(String(format: "%2.1f", "5") +  " miles")
                                .font(.custom(regularCustomFontName, size: 13))
                        }
                    }
                    Spacer()
                    
                    //MARK: PRICE
                    Text("$" + String(format: "%3.2f", restaurant.price))
                        .font(.custom(poppinsFontName, size: 16))
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 4, leading: 11, bottom: 4, trailing: 11))
                        .background(Color("FF5A60"))
                        .cornerRadius(4)
                }
            }.frame(width: imageWidth)
        }
    }
}





