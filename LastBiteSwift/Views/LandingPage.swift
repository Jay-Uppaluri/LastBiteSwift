// LANDING PAGE
//
//
//

import SwiftUI

struct LandingPage: View {
    var body: some View {
        NavigationView(){
            VStack(spacing:20) {
                        Spacer()
                        Spacer()
                        Spacer()
                        Image("Food Transparent")
                            .padding()
                        Image("LogoColor")
                        HStack(){
                            Text("Fighting food waste, one bite at a time.")
                        }

                            .font(.custom("DMSans-Regular", size: 16))
                            .foregroundColor(.gray)


                        Spacer()
                        Spacer()

                        NavigationLink(destination: SignUp()) {
                           Text("Sign Up")
                                 .frame(width: 358.0, height: 51.0)
                                 .accentColor(.white)
                                 .background(Color("AccentColor"))
                                 .cornerRadius(100.0)
                                 .font(.custom("DMSans-Bold", size: 16))

                        }

                        Button("Log In") {
                        }
                        .accentColor(Color("Body"))
                        .cornerRadius(100.0)
                        .font(.custom("DMSans-Bold", size: 16))

                    }


                    }

    }
    struct LandingPage_Previews: PreviewProvider {
        static var previews: some View {
            LandingPage()
        }
    }
}
