

import SwiftUI

var regularCustomFontName: String = "DMSans-Regular"
var mediumCustomFontName: String = "DMSans-Medium"
var boldCustomFontName: String = "DMSans-Bold"
var poppinsFontName: String = "Poppins-ExtraBoldItalic"

struct FavoritesPage: View {
    @ObservedObject private var viewModel = HomeViewModel()
    @EnvironmentObject private var userService: UserService

    var body: some View {
        NavigationView {
            //MARK: CONTENT
            ScrollView(.vertical){
                VStack(spacing: 24){
                    ForEach(viewModel.restaurants.indices, id: \.self) { index in
                        let isHeartToggled = Binding(
                            get: { userService.favorites.contains(viewModel.restaurants[index].id!) },
                            set: { newValue in
                                if newValue {
                                    userService.favorites.append(viewModel.restaurants[index].id!)
                                } else {
                                    userService.favorites.removeAll { $0 == viewModel.restaurants[index].id! }
                                }
                            }
                        )
                        RestaurantCardSubView(restaurant: viewModel.restaurants[index], isHeartToggled: isHeartToggled)
                    }
                }
                .padding()
            }
            
            //MARK: TOP BAR
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .principal) {
                    HStack{
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 93, height: 30)
                        Spacer()
                        
                        Button {
                            //MARK: CHANGE LOCATION BUTTON ACTION
                        } label: {
                            HStack{
                                Text("Minneapolis, MN")
                                    .font(.custom(boldCustomFontName, size: 13))
                                    .lineLimit(1)
                                Image(systemName: "chevron.down")
                                    .resizable()
                                    .frame(width: 8, height: 5)
                            }
                            .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(.gray, lineWidth: 1).opacity(0.50))
                        }
                        .buttonStyle(.plain)
                    }
                }
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
    }
}

struct FavoritesPage_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesPage()
    }
}



