// HOME SCREEN
//LINE 141


import SwiftUI

struct Card: View {
    @State private var isHeartToggled = false
    
    var body: some View {
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
            .frame(width: 245, height: 188)
            .background(Color.white)
            .cornerRadius(4)
            .shadow(radius: 0)
        }
    }
}


struct CardSet: View {
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                Card()
                Card()
                Card()
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
                    .foregroundColor(Color("Body"))
                
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
                            Text("Header")
                                .font(.custom("DMSans-Bold", size: 20))
                            Spacer()
                        }
                        
                        CardSet()
                    }
                    
                    Spacer().frame(height: 24)
                    
                    VStack{
                        HStack(){
                            Text("Header")
                                .font(.custom("DMSans-Bold", size: 20))
                            Spacer()
                        }
                        
                        CardSet()
                    }
                    
                    Spacer().frame(height: 24)
                    
                    VStack{
                        HStack(){
                            Text("Header")
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

struct HomeView_Previews: PreviewProvider {
        static var previews: some View {
            HomeView()
        }
    }
    

