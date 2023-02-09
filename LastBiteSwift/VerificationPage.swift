//  PHONE VERIFICATION SCREEN
//
//  TO DO
//  - set phone number placeholder to users phone number
//  - add black border to textfield when focused
//  - automatically move to next text field when 1 character is entered
//  - backend config for verification (code sending, autofill)
//  - error state if verification code is incorrect

import SwiftUI

struct VerificationPage: View {
    @State private var verNumber1: String = ""
    @State private var verNumber2: String = ""
    @State private var verNumber3: String = ""
    @State private var verNumber4: String = ""
    @State private var verNumber5: String = ""
    @State private var verNumber6: String = ""
    
    var body: some View {
        VStack(spacing: 40){
            Spacer().frame(height: 50)
            Text("Please verify your phone number by entering the code sent to +1 (555) 555-5555")
                .font(.custom("DMSans-Bold", size: 20))
                .multilineTextAlignment(.center)
            HStack(){
                TextField("", text: $verNumber1)
                    .frame(height: 90.0)
                    .background(Color("TextfieldColor"))
                    .cornerRadius(8.0)
                    .multilineTextAlignment(.center)
                    .font(.custom("DMSans-Bold", size: 31))
                    .keyboardType(.numberPad)
                    
                
                
                TextField("", text: $verNumber2)
                    .frame(height: 90.0)
                    .background(Color("TextfieldColor"))
                    .cornerRadius(8.0)
                    .multilineTextAlignment(.center)
                    .font(.custom("DMSans-Bold", size: 31))
                    .keyboardType(.numberPad)
                   
                
                TextField("", text: $verNumber3)
                    .frame(height: 90.0)
                    .background(Color("TextfieldColor"))
                    .cornerRadius(8.0)
                    .multilineTextAlignment(.center)
                    .font(.custom("DMSans-Bold", size: 31))
                    .keyboardType(.numberPad)
                
                TextField("", text: $verNumber4)
                    .frame(height: 90.0)
                    .background(Color("TextfieldColor"))
                    .cornerRadius(8.0)
                    .multilineTextAlignment(.center)
                    .font(.custom("DMSans-Bold", size: 31))
                    .keyboardType(.numberPad)
                
                TextField("", text: $verNumber5)
                    .frame(height: 90.0)
                    .background(Color("TextfieldColor"))
                    .cornerRadius(8.0)
                    .multilineTextAlignment(.center)
                    .font(.custom("DMSans-Bold", size: 31))
                    .keyboardType(.numberPad)
                
                TextField("", text: $verNumber6)
                    .frame(height: 90.0)
                    .background(Color("TextfieldColor"))
                    .cornerRadius(8.0)
                    .multilineTextAlignment(.center)
                    .font(.custom("DMSans-Bold", size: 31))
                    .keyboardType(.numberPad)
                
            }
            HStack(){
                Text("Didn't recieve a code?")
                    .font(.custom("DMSans-Regular", size: 13))
                    .multilineTextAlignment(.center)
                
                Button("Resend Code") {
                }
                .accentColor(Color("AccentColor"))
                .cornerRadius(100.0)
                .font(.custom("DMSans-Regular", size: 13))
            }
            Spacer()
        }
        .padding()
        
    }
}

struct VerificationPage_Previews: PreviewProvider {
    static var previews: some View {
        VerificationPage()
    }
}
