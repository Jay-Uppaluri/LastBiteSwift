// HOME SCREEN
//LINE 141


import SwiftUI

struct CardSet: View {
    let restaurants: [Restaurant]
    @State private var userFavorites: [String] = []
    @State private var userService = UserService()

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(restaurants.indices, id: \.self) { index in
                    let isHeartToggled = userFavorites.contains(restaurants[index].id!)
                    RestaurantCardView(restaurant: restaurants[index], isHeartToggled: isHeartToggled)
                }
            }
        }
        .onAppear {
            userService.fetchUserFavorites { fetchedFavorites in
                if let fetchedFavorites = fetchedFavorites {
                    userFavorites = fetchedFavorites
                }
            }
        }
    }
}





    
struct IconTextField: View {
        var icon: String
        @Binding var text: String
        
        var body: some View {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .foregroundColor(Color("PlaceholderText"))
                
                TextField("Search for Places or Services", text: $text)
                    .padding(.leading, 0)
                    .font(.custom("DMSans-Bold", size: 16))
                    .frame(height: 32)
                    .foregroundColor(.black)
                
            }
            .padding(.all, 8)
            .background(Color("TextfieldColor"))
            .cornerRadius(8)
            
        }
    }

struct HomeView: View {
    @StateObject var userService = UserService()
    @ObservedObject private var viewModel = HomeViewModel()
    @State private var selectedTab = 0
    @State private var searchplaceholder = ""
    var body: some View {
        let restaurants = viewModel.restaurants
        let pizza = restaurants.filter{ $0.type.contains("pizza") }
        let healthy = restaurants.filter{ $0.type.contains("healthy") }
        let fastFood = restaurants.filter { $0.type.contains("fast food") }
        
        NavigationView {
        TabView(selection: $selectedTab) {
            
            ScrollView {
                VStack(){
                    //Title and search bar VStack
                    VStack{
                        Image("LogoColor")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 24)
                        
                        Spacer().frame(height: 24)
                        
                        //this isn't showing
                        IconTextField(icon: "magnifyingglass", text: $searchplaceholder)
                        
                    }
                    
                    Spacer().frame(height: 24)
                    
                    
                    //Header with cards VStack
                    VStack{
                        HStack(){
                            Text("What's Nearby")
                                .font(.custom("DMSans-Bold", size: 20))
                            Spacer()
                        }
                        
                        CardSet(restaurants: pizza)
                    }
                    
                    Spacer().frame(height: 24)
                    
                    VStack{
                        HStack(){
                            Text("Healthy")
                                .font(.custom("DMSans-Bold", size: 20))
                            Spacer()
                        }
                        
                        CardSet(restaurants: healthy)
                    }
                    
                    Spacer().frame(height: 24)
                    
                    VStack{
                        HStack(){
                            Text("Fast food")
                                .font(.custom("DMSans-Bold", size: 20))
                            Spacer()
                        }
                        
                        CardSet(restaurants: fastFood)
                    }
                }.padding()
            }
            //only for ios 16.0
            //.toolbarBackground(Color.white, for: .tabBar)
            
            .tabItem {
                Image(systemName: "safari")
                    
                Text("Explore")
                    .font(.custom("DMSans-Regular", size: 13.0))
                
            }
            .tag(0)
            
            ContentView()
                .tabItem {
                    Image(systemName: "map")
                    Text("Discover")
                        .font(.custom("DMSans-Regular", size: 13.0))
                }
                .tag(1)
            
            FavoritesView()
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
                .tag(3)
        }
        .accentColor(Color("AccentColor"))
        .onAppear {
            Task {
                do {
                    try await viewModel.fetchData()
                } catch {
                    print("Error fetching data: \(error)")
                }
            }
        }
        .environmentObject(userService)
        //only for ios 16.0
        //.toolbarBackground(Color.white, for: .tabBar)
    }
    }
        
}

struct HomeView_Previews: PreviewProvider {
        static var previews: some View {
            HomeView()
        }
    }
    

