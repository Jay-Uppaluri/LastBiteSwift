import SwiftUI

struct SplashPage: View {
    var body: some View {
        VStack {
            Image("Food Transparent")
            Image("Logo")
                .padding(.bottom, 16)
            Image("slogan")
                .padding(.bottom, 40)
            Button(action: {
                            // Button action here
                        }) {
                            Text("Log In")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(EdgeInsets(top: 10, leading: 90, bottom: 10, trailing: 90))
                                .background(Color.pink)
                                .cornerRadius(10)
                        }
                        
                        Text("Sign up")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .padding(.top)
                    }
    }
}



struct SplashPage_Previews: PreviewProvider {
    static var previews: some View {
        SplashPage()
    }
}

