//  COMPONENTS
//  This file will be used to create multiple reusable components. This will include components such as Primary Buttons, Secondary Buttons, Headers, Menu Items, and more!

import SwiftUI


//1. Menu Item
//This is a menu item with an arrow pointing to a new screen. Add this to a screen by calling out MenuItem(menutext: "String")

struct menuItem: View {
    var menutext: String
    var body: some View {
        HStack(){
            Text(menutext)
                .font(.custom("DMSans-Regular", size: 18))
            Spacer()
            Image(systemName: "chevron.right")
        }
    }
}



//2. Primary Button
//Use this component for primary call to actions on screens

struct primaryButtonLarge: View {
    var text: String
    var body: some View {
        Button(action: {}) {
           Text(text)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 51)
            
              .background(Color("AccentColor"))
              .foregroundColor(.white)
              .cornerRadius(100)
              .font(.custom("DMSans-Bold", size:16))
        }
    }
}

//3. Secondary Button
//Use this component for secondary call to actions on screens
struct secondaryButtonLarge: View {
    var text: String
    var body: some View {
        Button(action: {}) {
           Text(text)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 51)
            
                .background(Color(.white))
              .foregroundColor(Color("Body"))
              .cornerRadius(100)
              .font(.custom("DMSans-Bold", size:16))
        }
    }
}

//2. Text Field
//Use this component for a basic text field. Call a binding variable using @State in the view struct when calling this

struct mainTextField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
        
           .padding(12)
           .frame(height: 55.0)
           .background(Color("TextfieldColor"))
           .cornerRadius(8)
           .foregroundColor(Color("Body"))
           .font(.custom("DMSans-Bold", size: 16))
    }
}



//Insert components into this struct to test the look on them. Added padding automatically in the VStack.

struct Components: View {
    @State private var searchplaceholder = ""
    var body: some View {
        VStack(){
            primaryButtonLarge(text: "Primary Button")
            secondaryButtonLarge(text: "Secondary Button")
            mainTextField(placeholder: "Hi", text: $searchplaceholder)
            menuItem(menutext: "Hello")
        }.padding()
        
    }
}



//PREVIEW
struct Components_Previews: PreviewProvider {
    static var previews: some View {
        Components()
    }
}

