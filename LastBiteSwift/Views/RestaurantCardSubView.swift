

import SwiftUI

struct RestaurantCardSubView: View {
    var imageWidth: Double = 358.0
    var imageHeight: Double = 140.0
        
    var restaurantName, restaurantImageName: String
    var restaurantIsNew, restarauntIsFavorite: Bool
    var restaurantPrice, restaurantDistanceInMiles: Double
    var restaurantOrdersLeft: Int

    
    var body: some View {
        VStack(alignment: .leading, spacing: 8){
            
            //MARK: IMAGE
            ZStack(alignment: .topTrailing) {
                Image(restaurantImageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: imageWidth, height: imageHeight)
                    .clipped()
                    .cornerRadius(4)
                VStack(alignment: .trailing){
                    if restarauntIsFavorite{
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                            .padding(15)
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
            HStack(alignment: .top){
                VStack(alignment: .leading, spacing: 5){
                    Text(restaurantName)
                        .font(.custom(boldCustomFontName, size: 16))
                        .lineLimit(1)
                    HStack(spacing: 8){
                        if restaurantIsNew{
                            HStack(spacing: 2){
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
                        Text(String(format: "%2.1f", restaurantDistanceInMiles) +  " miles")
                            .font(.custom(regularCustomFontName, size: 13))

                    }
                }
                Spacer()
                
                
                //MARK: PRICE
                Text("$" + String(format: "%3.2f", restaurantPrice))
                    .font(.custom(poppinsFontName, size: 16))
                    .foregroundColor(.white)
                    .padding(EdgeInsets(top: 4, leading: 11, bottom: 4, trailing: 11))
                    .background(Color("FF5A60"))
                    .cornerRadius(4)
            }
        }.frame(width: imageWidth)
    }
}

struct RestaurantCardSubView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantCardSubView(restaurantName: "Parlor Pizza", restaurantImageName: "restaurant-photo", restaurantIsNew: true, restarauntIsFavorite: true, restaurantPrice: 5.99, restaurantDistanceInMiles: 1.3, restaurantOrdersLeft: 5)
    }
}

