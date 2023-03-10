import SwiftUI

struct VerificationPage: View {
    @State var otpText: String = ""
    
    @FocusState private var isKeyboardShowing: Bool
    
    var body: some View {
        VStack(spacing: 40){
            Spacer().frame(height: 50)
            Text("Please verify your phone number by entering the code sent to +1 (555) 555-5555")
                .font(.custom("DMSans-Bold", size: 20))
                .multilineTextAlignment(.center)
            HStack(spacing: 0) {
                ///- OTP Text Boxes
                /// Change Count Based on your OTP text size
                ForEach(0..<6,id: \.self){ index in
                    OTPTextBox(index)
                }
            }
            .background(content: {
                TextField("", text: $otpText.limit(6))
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .frame(width: 1, height: 1)
                    .opacity(0.001)
                    .blendMode(.screen)
                    .focused($isKeyboardShowing)
            })
            .contentShape(Rectangle())
            .onTapGesture {
                isKeyboardShowing.toggle()
            }
            .padding(.bottom, 20)
            .padding(.top,10)
            
            
            primaryButtonLarge(text: "Verify")
//            Button {
//
//            } label : {
//                Text("Verify")
//                    .fontWeight(.bold)
//                    .foregroundColor(.white)
//                    .padding(.vertical,12)
//                    .frame(maxWidth: .infinity)
//                    .background {
//                        RoundedRectangle(cornerRadius: 6, style: .continuous)
//                            .fill(.blue)
//                    }
//
//            }
            .disableWithOpacity(otpText.count < 6)
        }
        
        .padding(.all)
        .frame(maxHeight: .infinity, alignment: .top)
        
    }
    
    //MARK: OTP Text Box
    @ViewBuilder
    func OTPTextBox(_ index: Int) ->some View {
        ZStack{
            if otpText.count > index {
                ///Finding Char At Index
                let startIndex = otpText.startIndex
                let charIndex = otpText.index(startIndex, offsetBy: index)
                let charToString = String(otpText[charIndex])
                Text(charToString)
            } else {
                Text(" ")
            }
        }
        .frame(width:45,height:90)
        .background() {
            let status = (isKeyboardShowing && otpText.count == index)
            RoundedRectangle(cornerRadius: 8.0, style: .continuous)
            //adding bold box over which box you're currently in
                .stroke(status ? .black : .gray,lineWidth: status ? 1: 0.5)
            //adding animation
                .animation(.easeInOut(duration: 0.2), value: status)
        }
        //.background(Color("TextfieldColor"))
        .font(.custom("DMSans-Bold", size: 31))
        .frame(maxWidth: .infinity)
    }
}


struct VerificationPage_Previews: PreviewProvider {
    static var previews: some View {
        VerificationPage()
    }
}

// MARK: View Extension
extension View {
    func disableWithOpacity(_ condition : Bool) -> some View {
        self
            .disabled(condition)
            .opacity(condition ? 0.6 : 1)
    }
}


//MARK: Binding <String> Extension
extension Binding where Value == String{
    func limit(_ length: Int)->Self{
        if self.wrappedValue.count > length{
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.prefix(length))
            }
        }
        return self
    }
}
