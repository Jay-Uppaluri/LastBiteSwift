//
//  EditPhoneNumber.swift
//  LastBiteSwift
//
//  Created by Cameron Motameni on 2/18/23.
//

import SwiftUI

struct EditPhoneNumber: View {
    @State private var placeholdertext = ""
    
    var body: some View {
        VStack{
            HStack(alignment: .center){
                Image(systemName: "arrow.backward")
                Spacer()
                Text("Edit Phone Number")
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
                Text("Phone Number")
                .font(.custom("DMSans-Bold", size: 16))
                .foregroundColor(Color(.black))
                Spacer()
            }
            mainTextField(placeholder: "Enter Phone Number", text: $placeholdertext)
            Spacer()
            
           
            
        }
        .padding()
    }
}

struct EditPhoneNumber_Previews: PreviewProvider {
    static var previews: some View {
        EditPhoneNumber()
    }
}
