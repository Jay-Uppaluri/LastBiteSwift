import SwiftUI

var regularCustomFontName: String = "DMSans-Regular"
var mediumCustomFontName: String = "DMSans-Medium"
var boldCustomFontName: String = "DMSans-Bold"
var poppinsFontName: String = "Poppins-ExtraBoldItalic"

struct FavoritesPage: View {
    @State private var selectedTab = 0

    @State private var cityName: String = "Loading City..."

    func applyAndFetchData(newCityName: String) {
        cityName = newCityName
        Task {
            do {
                try await viewModel.fetchData()
            } catch {
                print("Error fetching data: \(error)")
            }
        }
        withAnimation {
            self.isChangeAddressViewShowing = false
        }
    }
    @ObservedObject private var viewModel = HomeViewModel()
    @EnvironmentObject private var userService: UserService

    // Add this state variable
    @State private var isChangeAddressViewShowing = false

    var body: some View {
        ZStack {
            NavigationView {
                TabView(selection: $selectedTab) {
                    if viewModel.restaurants.isEmpty {
                        EmptyHomeView()
                            .tabItem {
                                Image(systemName: "safari")
                                Text("Explore")
                                    .font(.custom(regularCustomFontName, size: 13.0))
                            }
                        .tag(0) } else {
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
                    .padding(.top, -20)
                }
                .tabItem {
                    Image(systemName: "safari")
                        
                    Text("Explore")
                        .font(.custom("DMSans-Regular", size: 13.0))
                    
                }
                .tag(0)
                        }
                
                ContentView()
                    .tabItem {
                        Image(systemName: "map")
                        Text("Discover")
                            .font(.custom("DMSans-Regular", size: 13.0))
                    }
                    .tag(1)
                
                FavoritesView()
                    .environmentObject(userService)
                    .environmentObject(viewModel)
                    .tabItem {
                        Image(systemName: "heart")
                        Text("Favorites")
                            .font(.custom("DMSans-Regular", size: 13.0))
                    }
                    .tag(2)
                
                SettingsView()
                    .tabItem {
                        Image(systemName: "gearshape")
                        Text("Settings")
                            .font(.custom("DMSans-Regular", size: 13.0))
                    }
                    .tag(3)                }
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
                                print("Change address")
                                // Toggle isChangeAddressViewShowing to true when the button is tapped
                                self.isChangeAddressViewShowing = true
                            } label: {
                                HStack{
                                    Text(cityName)
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
                .navigationBarBackButtonHidden(true)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .onAppear {
                Task {
                    do {
                        try await viewModel.fetchData()
                        userService.fetchUserCityName { cityName in
                            self.cityName = cityName ?? "Unknown City"
                        }
                    } catch {
                        print("Error fetching data: \(error)")
                    }
                }
            }

            // Add this to present the ChangeAddressSubView when isChangeAddressViewShowing is true
            if isChangeAddressViewShowing {
                            VStack {
                                Spacer()

                                ChangeAddressSubView(onApply: applyAndFetchData)
                                    .transition(.move(edge: .bottom))
                            }
                            .background(
                                Color.black.opacity(0.4)
                                    .edgesIgnoringSafeArea(.all)
                                    .onTapGesture {
                                        withAnimation {
                                            self.isChangeAddressViewShowing = false
                                        }
                                    }
                            )
                

            
                
                
                        }
            
                    }
        
                }
            }

struct FavoritesPage_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesPage()
    }
}
