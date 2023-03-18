// HOME SCREEN
//LINE 141


import SwiftUI

struct CardSet: View {
    @ObservedObject private var viewModel = HomeViewModel()
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) { // Add ScrollView with horizontal axis layout
            HStack(spacing: 8) { // Add HStack with spacing
                ForEach(viewModel.restaurants) { restaurant in
                    RestaurantCardView(restaurant: restaurant)
                }
            }
        }
        .onAppear() {
            self.viewModel.fetchData()
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
    @State private var selectedTab = 0
    @State private var searchplaceholder = ""
    var body: some View {
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
                        
                        CardSet()
                    }
                    
                    Spacer().frame(height: 24)
                    
                    VStack{
                        HStack(){
                            Text("Your favorites")
                                .font(.custom("DMSans-Bold", size: 20))
                            Spacer()
                        }
                        
                        CardSet()
                    }
                    
                    Spacer().frame(height: 24)
                    
                    VStack{
                        HStack(){
                            Text("Recommended for you")
                                .font(.custom("DMSans-Bold", size: 20))
                            Spacer()
                        }
                        
                        CardSet()
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
            
            Text("Discover")
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
    

