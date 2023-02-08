//
//  LandingPage.swift
//  Last-Bite
//
//  Created by Jay Uppaluri on 2/7/23.
//

import SwiftUI

struct LandingPage: View {
    var body: some View {
        ZStack {
            Image("Splash")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
        }
    }
}

struct LandingPage_Previews: PreviewProvider {
    static var previews: some View {
        LandingPage()
    }
}



