//
//  HomeView.swift
//  cameronmotameni
//
//  Created by Aiden Seibel on 6/9/23.
//

import SwiftUI

struct EmptyHomeView: View {
    var imageWidth: Double = 170.0
    var imageHeight: Double = 85.0

    var headerImageWidth: Double = 100.0
    var headerImageHeight: Double = 30.0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
//                HStack{
//                    Image("LastBite")
//                        .resizable()
//                        .frame(width: headerImageWidth, height: headerImageHeight)
//                        .padding()
//                    Spacer()
//                    LocationDropDownView()
//                        .padding()
//                }
                Spacer()
                Image("OutForLunch")
                    .resizable()
                    .frame(width: imageWidth, height: imageHeight)
                
                VStack(spacing: 16){
                    Text("We're coming soon!")
                        .font(.custom("DMSans-Bold", size: 20))
                    Text("We’re expanding Last Bite at the speed of light! But looks like we’re not quite at your location yet.")
                        .font(.custom("DMSans-Regular", size: 16))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .frame(width: UIScreen.main.bounds.width * 0.80)
                Text("Change your location")
                    .font(.custom("DMSans-Medium", size: 16))
                    .foregroundColor(Color("FF5A60"))
                    
                    
                Spacer()
                Spacer()
            }
            //MARK: TOP BAR
            .navigationBarTitleDisplayMode(.inline)
            

        }
    }
}

struct EmptyHomeView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyHomeView()
    }
}

