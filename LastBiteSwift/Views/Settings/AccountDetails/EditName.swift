//
//  EditName.swift
//  LastBiteSwift
//
//  Created by Cameron Motameni on 2/18/23.
//

import SwiftUI

struct EditName: View {
    @State private var placeholdertext = ""
    var body: some View {
        
        VStack{
            HStack(alignment: .center){
                Image(systemName: "arrow.backward")
                Spacer()
                Text("Edit Name")
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
                Text("Name")
                .font(.custom("DMSans-Bold", size: 16))
                .foregroundColor(Color(.black))
                Spacer()
            }
            mainTextField(placeholder: "Enter Name", text: $placeholdertext)
            Spacer()
            
           
            
        }
        .padding()
    }
}

struct EditName_Previews: PreviewProvider {
    static var previews: some View {
        EditName()
    }
}
