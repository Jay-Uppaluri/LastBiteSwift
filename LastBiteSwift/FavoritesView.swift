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
    @State private var searchplaceholder = ""
    var body: some View {
        
        ScrollView{
            VStack(){
                
                Text("Favorites")
                    .font(.custom("DMSans-Bold", size: 20))
                    .foregroundColor(Color("AccentColor"))
                    .frame(width: 100, height: 24)
                
                Spacer().frame(height: 24)
                
                IconTextField(icon: "magnifyingglass", text: $searchplaceholder)
                
                Spacer().frame(height: 24)
                
                
                VStack{
                    CardLarge()
                    Spacer().frame(height: 24)
                    CardLarge()
                    Spacer().frame(height: 24)
                    CardLarge()
                    Spacer().frame(height: 24)
                    CardLarge()
                    Spacer().frame(height: 24)
                    CardLarge()
                }
            }
        }.padding()
    }
}
    
    struct FavoritesView_Previews: PreviewProvider {
        static var previews: some View {
            FavoritesView()
        }
    }
