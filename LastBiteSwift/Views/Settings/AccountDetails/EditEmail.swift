//
//  EditEmail.swift
//  LastBiteSwift
//
//  Created by Cameron Motameni on 2/18/23.
//

import SwiftUI

struct EditEmail: View {
    @State private var placeholdertext = ""
    
    var body: some View {
        VStack{
            HStack(alignment: .center){
                Image(systemName: "arrow.backward")
                Spacer()
                Text("Edit Email")
                    .font(.custom("DMSans-Bold", size: 20))
                    .foregroundColor(Color(.black))
                    .multilineTextAlignment(.center)
                    .frame(width: .infinity)
                Spacer()
                Image(systemName: "checkmark")
                .foregroundColor(Color(.black))
            }
            
            
            
            Spacer().frame(height: 32)
            HStack{
                Text("Email")
                .font(.custom("DMSans-Bold", size: 16))
                .foregroundColor(Color(.black))
                Spacer()
            }
            mainTextField(placeholder: "Enter Email Address", text: $placeholdertext)
            Spacer()
            
           
            
        }
        .padding()
    }
}

struct EditEmail_Previews: PreviewProvider {
    static var previews: some View {
        EditEmail()
    }
}
