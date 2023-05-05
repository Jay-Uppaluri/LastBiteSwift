//
//  PopUpView.swift
//  jayuppaluri
//
//  Created by Aiden Seibel on 4/27/23.
//

import SwiftUI

struct PaymentPopUpView: View {
    private var regularCustomFontName: String = "DMSans-Regular"
    private var mediumCustomFontName: String = "DMSans-Medium"
    private var boldCustomFontName: String = "DMSans-Bold"
    
    private var imageName: String = "surprise-bite-image"
    
    private var nameOfRestaurant: String = "Pizza Place"
    private var pickUpTimeBegins: String = "8AM"
    private var pickUpTimeEnds: String = "10PM"
    
    private var numberOfSurpriseBites: Int = 1
    
    private var subtotalAmount: Double = 5.99
    private var salesTaxAmount: Double = 0.47
    
    private var paymentOnHand: String = "Visa..x4444"

    var body: some View {
        VStack(alignment: .leading, spacing: 16){
            //MARK: HEADER
            Group{
                VStack(spacing: 10){
                    ZStack{
                        VStack(alignment: .center, spacing: 2){
                            HStack{
                                Spacer()
                                Text(nameOfRestaurant)
                                    .font(.custom(boldCustomFontName, size: 13))
                                Spacer()
                            }
                            Text("Pickup today \(pickUpTimeBegins) to \(pickUpTimeEnds)")
                                .font(.custom(regularCustomFontName, size: 13))
                        }
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
                    Divider()
                }
            }
            
            //MARK: YOUR ORDER
            Group{
                Text("Your Order")
                    .font(.custom(boldCustomFontName, size: 13))
                HStack(alignment: .center, spacing: 10){
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                    VStack(alignment: .leading, spacing: 4){
                        HStack{
                            Text("Surprise Bite!")
                                .font(.custom(boldCustomFontName, size: 13))
                            Text("x\(numberOfSurpriseBites)")
                                .font(.custom(boldCustomFontName, size: 13))
                                .opacity(0.50)
                        }
                        Text("Our partners range from bakeries to restaurants, so your order will always be a surprise!")
                            .lineLimit(2)
                            .font(.custom(regularCustomFontName, size: 13))
                            .opacity(0.70)
                    }
                }
                Divider()
            }
            
            //MARK: ORDER SUMMARY
            Group{
                Text("Order Summary")
                    .font(.custom(boldCustomFontName, size: 13))

                VStack(alignment: .center, spacing: 8){
                    HStack{
                        Text("Subtotal")
                            .font(.custom(regularCustomFontName, size: 13))
                        Spacer()
                        Text("$\(String(format: "%0.2f", subtotalAmount))")
                            .font(.custom(regularCustomFontName, size: 13))
                    }
                    .opacity(0.70)

                    HStack{
                        Text("Sales Tax")
                            .font(.custom(regularCustomFontName, size: 13))
                        Spacer()
                        Text("$\(String(format: "%0.2f", salesTaxAmount))")
                            .font(.custom(regularCustomFontName, size: 13))
                    }
                    .opacity(0.70)

                    HStack{
                        Text("Total")
                            .font(.custom(regularCustomFontName, size: 16))
                        Spacer()
                        Text("$\(String(format: "%0.2f", subtotalAmount + salesTaxAmount))")
                            .font(.custom(regularCustomFontName, size: 16))
                    }
                }
                Divider()
            }
            
            //MARK: PAYMENT
            Group{
                HStack{
                    Text("Payment")
                        .font(.custom(boldCustomFontName, size: 13))
                    Spacer()
                    Button {
                        //can change to a navigation link
                    } label: {
                        HStack{
                            Text(paymentOnHand)
                                .font(.custom(regularCustomFontName, size: 13))
                            Image(systemName: "chevron.right")
                                .resizable()
                                .frame(width: 5, height:8)
                        }
                    }
                    .buttonStyle(.plain)
                }
                Divider()
            }

            //MARK: FOOTER / PLACE ORDER
            Group{
                VStack(alignment: .center, spacing: 8){
                    Text("If you have any questions about allergens or specifc ingredients, please contact the store.")
                        .font(.custom(regularCustomFontName, size: 11))
                        .multilineTextAlignment(.center)
                        .opacity(0.40)
                    
                    //MARK: PLACE ORDER BUTTON
                    NavigationLink(destination: PaymentConfirmationView()) {
                        HStack{
                            Spacer()
                            Text("Place Order")
                                .font(.custom(boldCustomFontName, size: 16))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
                        .background(Color("FF5A60"))
                        .cornerRadius(UIScreen.main.bounds.width * 0.20)
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .padding(16)
        .cornerRadius(10)
    }
}

struct PaymentPopUpView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentPopUpView()
    }
}
