// SPLASH SCREEN VIEW
// color background with white logo asset
//

import SwiftUI

struct SplashScreenView: View {
    
    @State private var isActive = false
    
   
    var body: some View {
        if isActive {
            LandingPage()
        } else {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Image("LogoWhite")
                    Spacer()
                }
                Spacer()
            }.background(Color.accentColor)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now()+2.0){
                        withAnimation {
                            self.isActive = true
                        }
                        
                    }
                }
        }
        }
        
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
