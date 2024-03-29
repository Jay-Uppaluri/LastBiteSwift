import SwiftUI
import Firebase
import FirebaseAuth

struct LogIn: View {

    @State private var emailAddress: String = ""
    @State private var passWord: String = ""
    @State private var isLoggedIn: Bool = false

    var body: some View {
        if isLoggedIn {
            FavoritesPage()
        } else {
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
                            isLoggedIn = true
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

