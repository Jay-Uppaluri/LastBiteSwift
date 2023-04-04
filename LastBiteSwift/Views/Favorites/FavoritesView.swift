// FAVORITES SCREEN
//

import SwiftUI

struct CardLarge: View {
    var body: some View{
        VStack(spacing: 8) {
            Image("card-image")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 358, height: 140)
                .cornerRadius(4)
    
    HStack(){
        VStack(spacing: 2){
            HStack(){
                Text("<Restaurant Title>")
                    .font(.custom("DMSans-Bold", size: 16))
                Spacer()
            }
            HStack(spacing: 6){
                Text("4.9")
                    .font(.custom("DMSans-Regular", size: 13))
                
                Image(systemName: "star.fill")
                    .resizable()
                    .frame(width: 10.0, height: 10.0)
        
                
                Text("∙")
                    .font(.custom("DMSans-Regular", size: 13))
                
                Text("6 miles")
                    .font(.custom("DMSans-Regular", size: 13))
                Spacer()
            }
            
            .foregroundColor(.gray)
            
        }
        Text("$4.99")
            .font(.custom("DMSans-Bold", size: 16))
            .frame(width: 68, height: 27)
            .background(Color("AccentColor"))
            .foregroundColor(.white)
            .cornerRadius(4.0)
        
        
    }
            
        }
        
        .frame(width: 358, height: 188)
        .background(Color.white)
        .cornerRadius(4)
    }
}
    
    
struct FavoritesView: View {
    @EnvironmentObject var userService: UserService
    @EnvironmentObject var homeViewModel: HomeViewModel
    @State private var favorites: [String] = []
    
    var favoriteRestaurants: [Restaurant] {
        return homeViewModel.restaurants.filter { restaurant in
            favorites.contains(restaurant.id ?? "")
        }
    }
    
    var body: some View {
            VStack {
                Text("Your Favorite Restaurants")
                    .font(.title)
                    .padding()
                
                ScrollView {
                    VStack {
                        ForEach(favoriteRestaurants) { restaurant in
                            let isHeartToggled = Binding(
                                get: { favorites.contains(restaurant.id ?? "") },
                                set: { newValue in
                                    if newValue {
                                        favorites.append(restaurant.id ?? "")
                                    } else {
                                        favorites.removeAll { $0 == restaurant.id! }
                                    }
                                }
                            )
                            RestaurantCardView(restaurant: restaurant, isHeartToggled: isHeartToggled) {
                                if let index = favorites.firstIndex(of: restaurant.id ?? "") {
                                    favorites.remove(at: index)
                                }
                            }
                            .padding(.bottom)
                        }
                    }
                }
            }
            .onAppear {
                userService.fetchUserFavorites { fetchedFavorites in
                    favorites = fetchedFavorites ?? []
                }
            }
        }
    }

    struct FavoritesView_Previews: PreviewProvider {
        static var previews: some View {
            FavoritesView()
        }
    }
