//
//  NewPaymentMethod.swift
//  LastBiteSwift
//
//  Created by Cameron Motameni on 2/18/23.
//

import SwiftUI

struct NewPaymentMethod: View {
    @State private var cardnumber = ""
    @State private var expiration: String = ""
    @State private var CVC: String = ""
    @State private var zipcode: String = ""
    @State private var isSubscribed: Bool = false
    
    var body: some View {
        VStack{
            HStack(alignment: .center){
                Image(systemName: "arrow.backward")
                Spacer()
                Text("New Payment Method")
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
                VStack {
                    HStack{
                        Text("Card Number")
                            .font(.custom("DMSans-Bold", size: 16))
                        .foregroundColor(Color(.black))
                        Spacer()
                    }
                    mainTextField(placeholder: "XXXX XXXX XXXX XXXX", text: $cardnumber)
                }
            }
            Spacer().frame(height: 24)
            HStack(spacing: 12){
                VStack {
                    HStack{
                        Text("Expiration")
                            .font(.custom("DMSans-Bold", size: 16))
                        .foregroundColor(Color(.black))
                        Spacer()
                    }
                    mainTextField(placeholder: "MM/YY", text: $expiration)
                }
                VStack {
                    HStack{
                        Text("CVC")
                            .font(.custom("DMSans-Bold", size: 16))
                        .foregroundColor(Color(.black))
                        Spacer()
                    }
                    mainTextField(placeholder: "CVC", text: $CVC)
                }
                VStack {
                    HStack{
                        Text("Zip Code")
                            .font(.custom("DMSans-Bold", size: 16))
                        .foregroundColor(Color(.black))
                        Spacer()
                    }
                    mainTextField(placeholder: "ZIP", text: $zipcode)
                }
            }
            Spacer().frame(height: 12)
            HStack {
               Button(action: { self.isSubscribed.toggle() }) {
                  Image(systemName: self.isSubscribed ? "checkmark.square" : "square")
               }
               
               Text("Set as default payment method")
                    .font(.custom("DMSans-Regular", size: 13))
               Spacer()
            }
            Spacer()
            
        }
       
        .padding()
    }
}

struct NewPaymentMethod_Previews: PreviewProvider {
    static var previews: some View {
        NewPaymentMethod()
    }
}
