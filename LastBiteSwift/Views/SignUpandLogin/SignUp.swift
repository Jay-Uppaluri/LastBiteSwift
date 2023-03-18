// SIGN UP PAGE
//
// TO DO:
// - update Mobile Number text field so it inputs in format of phone number only
// - add the option to clear field on each text field (X button at end of text field)
// - Error states for invalid fields
// - Sign Up nav to verification code


import SwiftUI
import Firebase

struct SignUp: View {
   @State private var mobileNumber: String = ""
   @State private var fullName: String = ""
   @State private var emailAddress: String = ""
   @State private var passWord: String = ""
   @State private var isSubscribed: Bool = false
   @State private var isEditingFullName = false

   var body: some View {

      VStack(alignment: .leading, spacing: 20) {
         Text("Sign Up")
            .font(.custom("DMSans-Bold", size: 39))
            .padding(.top, 8)
         VStack(alignment: .leading, spacing: 10) {
             TextField("Mobile Number", text: $mobileNumber)
               .padding(12)
               .frame(height: 55.0)
               .background(Color("TextfieldColor"))
               .cornerRadius(8)
               .foregroundColor(Color("Body"))
               .font(.custom("DMSans-Bold", size: 16))
               .keyboardType(.phonePad)

        
             TextField("Full Name", text: $fullName)
               .padding(12)
               .frame(height: 55.0)
               .background(Color("TextfieldColor"))
               .cornerRadius(8)
               .foregroundColor(Color("Body"))
               .font(.custom("DMSans-Bold", size: 16))


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

         
          HStack {
              Button(action: { self.isSubscribed.toggle() }) {
                  Image(systemName: self.isSubscribed ? "checkmark.square" : "square")
              }

              Text("I would like to subscribe to receive alerts from Last Bite for personalized campaigns, advertisements, and promotions")
                  .font(.custom("DMSans-Regular", size: 13))
          }
          Button {
              register()
          } label : {
              Text("Sign Up")
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



    func register() {
        Auth.auth().createUser(withEmail: emailAddress, password: passWord) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                let user = Auth.auth().currentUser
                let userId = user?.uid
                if let userId = userId {
                    UserService.addUserToFirestore(uid: userId, name: "John placeholder", email: emailAddress)
                    user?.sendEmailVerification(completion: { error in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            print("Verification email sent to \(emailAddress)")
                        }
                    })
                }
            }
        }
    }

}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}


