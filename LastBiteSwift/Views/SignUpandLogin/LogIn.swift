// SIGN UP PAGE
//
// TO DO:
// - update Mobile Number text field so it inputs in format of phone number only
// - add the option to clear field on each text field (X button at end of text field)
// - Error states for invalid fields
// - Sign Up nav to verification code


import SwiftUI
import Firebase

struct LogIn: View {

   @State private var emailAddress: String = ""
   @State private var passWord: String = ""

   var body: some View {

      VStack(alignment: .leading, spacing: 20) {
         Text("Log In")
            .font(.custom("DMSans-Bold", size: 39))
            .padding(.top, 8)
         VStack(alignment: .leading, spacing: 10) {

            TextField("Email Address", text: $emailAddress)
               .padding(12)
               .frame(height: 55.0)
               .background(Color("TextfieldColor"))
               .cornerRadius(8)
               .foregroundColor(Color("Body"))
               .font(.custom("DMSans-Bold", size: 16))


             TextField("Password", text: $passWord)
                .padding(12)
                .frame(height: 55.0)
                .background(Color("TextfieldColor"))
                .cornerRadius(8)
                .foregroundColor(Color("Body"))
                .font(.custom("DMSans-Bold", size: 16))

         }

         

          Button(action: {
              login(email: emailAddress, password: passWord) { _, error in
                  if let error = error {
                      print("Error logging in: \(error.localizedDescription)")
                  } else {
                      print("User logged in successfully!")
                      // Navigate to the next screen or perform any other action after logging in
                  }
              }
          }) {

              Text("Log In")
                  .frame(width: 358, height: 51)
                  .background(Color("AccentColor"))
                  .foregroundColor(.white)
                  .cornerRadius(100)
                  .font(.custom("DMSans-Bold", size:16))
          }
         Spacer()
      }
      .padding([.top, .leading, .trailing], 20)

   }

    

    func login(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            completion(authResult, error)
        }
    }

}





struct LogIn_Previews: PreviewProvider {
    static var previews: some View {
        LogIn()
    }
}
