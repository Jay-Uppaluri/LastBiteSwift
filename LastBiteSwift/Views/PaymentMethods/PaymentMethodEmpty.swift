//
//  PaymentMethodEmpty.swift
//  LastBiteSwift
//
//  Created by Cameron Motameni on 2/18/23.
//

import SwiftUI

struct PaymentMethodEmpty: View {
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
                Spacer().frame(width: 24)
            }
            Spacer().frame(height: 100)
            Image("NoPaymentMethod")
            Text("Nothing to See Here!")
                .multilineTextAlignment(.center)
                .font(.custom("DMSans-Bold", size: 20))
                .foregroundColor(Color(.black))
            Spacer().frame(height: 12)
            Text("You can add a card to your account here. We also support the following payment methods at checkout:")
                .multilineTextAlignment(.center)
                .font(.custom("DMSans-Regular", size: 16))
                .foregroundColor(Color(.black))
            Spacer().frame(height: 12)
            
            HStack{
                Image(systemName: "apple.logo")
                Text("Pay")
            }
            .padding(.all, 8.0)
            .border(/*@START_MENU_TOKEN@*/Color.gray/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
            
            
            Spacer()
            
            primaryButtonLarge(text: "Add a New Payment Method")
        }
        .padding()
    }
}

struct PaymentMethodEmpty_Previews: PreviewProvider {
    static var previews: some View {
        PaymentMethodEmpty()
    }
}
