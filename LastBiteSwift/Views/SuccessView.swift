import SwiftUI

struct SuccessView: View {
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height : 86)
            
            Text("Success!")
                .font(.custom("DMSans-Bold", size: 50))
                .bold()
            
            Text("You've successfully verified your account! We've also sent you a confirmation to your email.")
                .font(.custom("DMSans-Regular", size: 20))
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding()
            
            
            Spacer().frame(height : 44)
            Image("Success")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:120,height:120)
            
            
            Spacer()
            
            Button(action: {}) {
               Text("Grab the Last Bite")
                  .frame(width: 358, height: 51)
                  .background(Color("AccentColor"))
                  .foregroundColor(.white)
                  .cornerRadius(100)
                  .font(.custom("DMSans-Bold", size:16))
            }
            
            
        }.padding()
    }
}



struct SuccessView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessView()
    }
}
