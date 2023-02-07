//
//  Login.swift
//  Last-Bite
//
//  Created by Jay Uppaluri on 2/7/23.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct Login: View {
    @State private var email = ""
    @State private var password = ""
    let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)

    var body: some View {
        VStack {
            Text("Log In")
                .font(.custom("DMSans-Bold", size: 39))
                .fontWeight(.bold)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .padding(.bottom, 200)
                .padding(.trailing, 190)
            
            Text("Email")
                .font(.custom("DMSans-Bold", size:16))
                .padding(.trailing, 280)
            TextField("", text: $email)
                .padding()
                .background(lightGreyColor)
                .cornerRadius(5.0)
                .padding(.bottom, 10)
                .padding(.trailing, 10)
                .padding(.leading, 10)
            
            Text("Password")
                .font(.custom("DMSans-Bold", size:16))
                .padding(.trailing, 251)
            TextField("", text: $password)
                .padding()
                .background(lightGreyColor)
                .cornerRadius(5.0)
                .padding(.bottom, 50)
                .padding(.trailing, 10)
                .padding(.leading, 10)
            
            Button(action: {
                login()
                        }) {
                            Text("Log In")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(EdgeInsets(top: 10, leading: 130, bottom: 10, trailing: 130))
                                .background(Color.pink)
                                .cornerRadius(10)
                        }
                        .padding(.bottom, 60)
        }
    }
    
    func login() {
          Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
              if error != nil {
                  print(error?.localizedDescription ?? "")
              } else {
                  print("success")
              }
          }
      }
}


struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}

