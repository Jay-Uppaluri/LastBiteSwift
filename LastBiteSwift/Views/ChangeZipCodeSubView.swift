

import SwiftUI

struct ChangeZipCodeSubView: View {
    @State var textFieldText: String = ""
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .center, spacing: 0){
            
            //MARK: HEADER
            ZStack(alignment: .top){
                Text("Change your Location")
                    .font(.custom(boldCustomFontName, size: 13))
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                HStack{
                    Spacer()
                    Button {
                        //MARK: CANCEL POPUP ACTION
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .buttonStyle(.plain)
                }
            }
            
            //MARK: TEXT FIELD
            HStack(spacing: 9){
                Spacer()
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .opacity(0.30)
                    .frame(width: 17, height: 17)
                TextField("Enter your Zip Code", text: $textFieldText)
                    .font(.custom(boldCustomFontName, size: 16))
                    .foregroundColor(colorScheme == .dark ? .black : .white)
                    .multilineTextAlignment(.center)
                    .frame(width: 153)
                Spacer()
            }
            .padding(15)
            .background(Color("F4F4F6"))
            .cornerRadius(8)
            
            
            //MARK: BUTTONS
            Button {
                //MARK: APPLY BUTTON ACTION
            } label: {
                HStack{
                    Spacer()
                    Text("Apply")
                        .font(.custom(boldCustomFontName, size: 16))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
                .background(Color("FF5A60"))
                .cornerRadius(UIScreen.main.bounds.width * 0.20)
                .buttonStyle(.plain)
                .padding(EdgeInsets(top: 31, leading: 0, bottom: 15, trailing: 0))

            }.buttonStyle(.plain)
            
            
            Button {
                //MARK: USE CURRENT LOCATION BUTTON ACTION
            } label: {
                HStack(alignment: .center, spacing: 8){
                    Image("location-sprite")
                        .resizable()
                        .frame(width: 14, height: 14)
                    Text("Use my current location")
                        .font(.custom(boldCustomFontName, size: 16))
                        .foregroundColor(Color("FF5A60"))
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 31, trailing: 0))
            }.buttonStyle(.plain)
        }
        .padding(16)
        .background(colorScheme == .dark ? .black : .white)
        .cornerRadius(8)
    }
}

struct ChangeZipCodeSubView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeZipCodeSubView()
    }
}
