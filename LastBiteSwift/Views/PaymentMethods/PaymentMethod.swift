//
//  PaymentMethod.swift
//  LastBiteSwift
//
//  Created by Cameron Motameni on 2/18/23.
//

import SwiftUI

struct PaymentMethod: View {
    @State private var placeholdertext = ""
    
    var body: some View {
        VStack{
            HStack(alignment: .center){
                Image(systemName: "arrow.backward")
                Spacer()
                Text("Payment Methods")
                    .font(.custom("DMSans-Bold", size: 20))
                    .foregroundColor(Color(.black))
                    .multilineTextAlignment(.center)
                    .frame(width: .infinity)
                Spacer()
                Image(systemName: "plus")
                .foregroundColor(Color(.black))
            }
            
            
            
            Spacer().frame(height: 32)
            
            HStack(){
                Image(systemName: "creditcard.fill")
                Spacer().frame(width:12)
                VStack(alignment: .leading){
                    HStack(spacing: 0){
                        Text("Credit Card Name")
                            .font(.custom("DMSans-Regular", size: 16))
                        Text("....5555")
                            .font(.custom("DMSans-Regular", size: 16))
                    }
                    Text("Expiring 01/25")
                        .font(.custom("DMSans-Regular", size: 16))
                }
                Spacer()
            }
            .padding(.all, 12.0)
            .border(/*@START_MENU_TOKEN@*/Color.gray/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
            Spacer()
            

        }
        .padding()
    }
}

struct PaymentMethod_Previews: PreviewProvider {
    static var previews: some View {
        PaymentMethod()
    }
}
