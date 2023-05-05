//
//  OrderConfirmationView.swift
//  jayuppaluri
//
//

import SwiftUI

struct PaymentConfirmationView: View {
    private var regularCustomFontName: String = "DMSans-Regular"
    private var mediumCustomFontName: String = "DMSans-Medium"
    private var boldCustomFontName: String = "DMSans-Bold"
    private var confirmationCodeFontName: String = "Poppins-Bold"
    
    private var imageName: String = "surprise-bite-image"

    private var confirmationCode: Int = 888888
    
    private var pickUpTimeBegins: String = "8AM"
    private var pickUpTimeEnds: String = "10PM"
    
    private var restaurantAddress: String = "1050 W Pleasant Ave, Chicago IL, 60611"

    private var subtotalAmount: Double = 5.99
    private var salesTaxAmount: Double = 0.47
    
    var body: some View {
        ScrollView(.vertical){
            VStack(spacing: 20){
                //MARK: HEADER
                VStack(alignment: .center, spacing: 8){
                    ZStack{
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .padding(10)
                        
                        //"x" mark in corner
                        VStack{
                            HStack{
                                Spacer()
                                Button {
                                    //MARK: DISMISS ACTION
                                } label: {
                                    Image(systemName: "xmark")
                                }
                                .buttonStyle(.plain)
                            }
                            Spacer()
                        }
                    }
                    Text("You Snagged the Last Bite!")
                        .font(.custom(boldCustomFontName, size: 16))
                    Text("Show the confirmation code below to the restaurant staff below during your pickup window to receive your surprise bite!")
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                        .font(.custom(regularCustomFontName, size: 13))
                        .opacity(0.70)
                    
                    Button {
                        //MARK: NEED ASSISTANCE ACTION
                    } label: {
                        Text("Need Assistance?")
                            .foregroundColor(Color("FF5A60"))
                            .font(.custom(regularCustomFontName, size: 11))
                    }
                }
                
                //MARK: CONFIRMATION CODE
                Text(String(confirmationCode))
                    .foregroundColor(Color("FF5A60"))
                    .font(.custom(confirmationCodeFontName, size: 25))
                    .tracking(8)
                    .padding(10)
                    .background(Color("FFF1F2"))
                    .padding(EdgeInsets(top: 32, leading: 0, bottom: 64, trailing: 0))
                
                //MARK: ORDER INFO
                Group{
                    //pickup window
                    HStack{
                        Text("Pickup Window")
                            .font(.custom(boldCustomFontName, size: 13))
                        Spacer()
                        Text("\(pickUpTimeBegins) to \(pickUpTimeEnds)")
                            .font(.custom(regularCustomFontName, size: 13))
                    }
                    Divider()
                    //location
                    HStack{
                        Text("Location")
                            .font(.custom(boldCustomFontName, size: 13))
                        Spacer()
                        Text(restaurantAddress)
                            .foregroundColor(Color("FF5A60"))
                            .font(.custom(regularCustomFontName, size: 13))
                            .lineLimit(1)
                            //.underline()
                    }
                    Divider()
                }

                //MARK: ORDER SUMMARY
                Group{
                    VStack(alignment: .leading, spacing: 16){
                        Text("Order Summary")
                            .font(.custom(boldCustomFontName, size: 13))
                        VStack(alignment: .center, spacing: 8){
                            //subtotal
                            HStack{
                                Text("Subtotal")
                                    .font(.custom(regularCustomFontName, size: 13))
                                    .opacity(0.70)
                                Spacer()
                                Text("$\(String(format: "%0.2f", subtotalAmount))")
                                    .font(.custom(regularCustomFontName, size: 13))
                                    .opacity(0.70)
                            }
                            .opacity(0.70)
                            
                            //sales tax
                            HStack{
                                Text("Sales Tax")
                                    .font(.custom(regularCustomFontName, size: 13))
                                    .opacity(0.70)
                                Spacer()
                                Text("$\(String(format: "%0.2f", salesTaxAmount))")
                                    .font(.custom(regularCustomFontName, size: 13))
                                    .opacity(0.70)
                            }
                            .opacity(0.70)

                            //total
                            HStack{
                                Text("Total")
                                    .font(.custom(regularCustomFontName, size: 13))
                                Spacer()
                                Text("$\(String(format: "%0.2f", subtotalAmount + salesTaxAmount))")
                                    .font(.custom(regularCustomFontName, size: 13))
                            }
                        }
                    }
                }
                //MARK: FOOTER BUTTONS
                VStack(spacing: 16){
                    Button {
                        //MARK: BACK TO HOME ACTION
                    } label: {
                        HStack{
                            Spacer()
                            Text("Back to Home")
                                .font(.custom(boldCustomFontName, size: 16))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
                        .background(Color("FF5A60"))
                        .cornerRadius(UIScreen.main.bounds.width * 0.20)
                    }
                    
                    Button {
                        //MARK: PICKED UP ACTION
                    } label: {
                        Text("I've Picked Up This Order")
                            .font(.custom(boldCustomFontName, size: 16))
                            .foregroundColor(Color("FF5A60"))
                    }
                }
            }
            .padding(16)
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        //.scrollIndicators(.hidden)
    }
}

struct PaymentConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentConfirmationView()
    }
}
