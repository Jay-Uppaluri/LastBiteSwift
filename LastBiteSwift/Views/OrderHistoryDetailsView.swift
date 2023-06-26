//
//  OrderHistoryDetails.swift
//  cameronmotameni
//
//  Created by Aiden Seibel on 6/9/23.
//

import SwiftUI

struct OrderHistoryDetailsView: View {
    var titleFontSize: Double = 25.0
    var regularFontSize: Double = 13.0
    var buttonFontSize: Double = 16.0
    var spacing: Double = 24.0
    
    var order: OrdersModel
    var paymentMethod: String = "Apple Pay" // Need to fetch this info from an appropriate data source
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            ScrollView{
                VStack(spacing: spacing){
                    Image("dominosLogo") // This should also be fetched based on the restaurant id
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .shadow(color: .gray, radius: 4, x: 0, y: 2)
                    
                    
                    VStack(spacing: 8){
                        Text("Pizza Place") // This should also be fetched based on the restaurant id
                            .font(.custom("DMSans-Medium", size: CGFloat(titleFontSize)))
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(Color("1B5346"))
                                .frame(width: 13, height: 13)
                            Text("Picked Up")
                                .foregroundColor(Color("1B5346"))
                                .font(.custom("DMSans-Bold", size: CGFloat(regularFontSize)))
                        }
                        .padding(10)
                        .background(Color("DFF9F3"))
                        .cornerRadius(10)
                    }
                    
                    
                    //MARK: DETAILS
                    Group{
                        VStack{
                            HStack{
                                Text("Order Id")
                                    .font(.custom("DMSans-Bold", size: CGFloat(regularFontSize)))
                                Spacer()
                                Text(String(order.orderNumber))
                                    .font(.custom("DMSans-Regular", size: CGFloat(regularFontSize)))
                            }
                            Divider()

                        }
                        

//                        VStack{
//                            HStack{
//                                Text("Order Details")
//                                    .font(.custom("DMSans-Bold", size: CGFloat(regularFontSize)))
//                                Spacer()
//                                VStack(alignment: .trailing, spacing: 2){
//                                    // You need to loop over the items in the order
//                                    ForEach(order.items, id: \.self){ item in
//                                        Text("\(item.name) x\(item.quantity)")
//                                            .font(.custom("DMSans-Regular", size: CGFloat(regularFontSize)))
//                                    }
//                                }
//                            }
//                            Divider()
//
//                        }
                        
                        
                        VStack{
                            HStack{
                                Text("Total")
                                    .font(.custom("DMSans-Bold", size: CGFloat(regularFontSize)))
                                Spacer()
                                Text("$\(formatNumber(_: Double(order.amount)))")
                                    .font(.custom("DMSans-Regular", size: CGFloat(regularFontSize)))
                            }
                            Divider()
                        }
                        
                        
                        VStack{
                            HStack{
                                Text("Location")
                                    .font(.custom("DMSans-Bold", size: CGFloat(regularFontSize)))
                                Spacer()
                                Button(action: {
                                    //MARK: OPEN THE MAP
                                }, label: {
                                    Text(order.address)
                                        .font(.custom("DMSans-Regular", size: CGFloat(regularFontSize)))
                                        .foregroundColor(Color("FF5A60"))
                                        .underline()
                                })
                            }
                            Divider()

                        }
                        

                        VStack{
                            HStack{
                                Text("Picked Up")
                                    .font(.custom("DMSans-Bold", size: CGFloat(regularFontSize)))
                                Spacer()
                                VStack(alignment: .trailing, spacing: 2){
                                    Text(order.timestamp, formatter: dateFormatter)
                                        .font(.custom("DMSans-Regular", size: CGFloat(regularFontSize)))
                                }
                            }
                            Divider()
                        }
                        

                        VStack{
                            HStack{
                                Text("Payment Method")
                                    .font(.custom("DMSans-Bold", size: CGFloat(regularFontSize)))
                                Spacer()
                                Text(paymentMethod)
                                    .font(.custom("DMSans-Regular", size: CGFloat(regularFontSize)))
                            }
                        }
                        
                        Divider()
                
                    }
                }
                    .padding(16)
                    .navigationBarTitle("")
                    .navigationBarBackButtonHidden(true)
                    .navigationBarItems(leading: backButton)
                    .navigationBarTitleDisplayMode(.inline)
            }
            Spacer()
            
            
            //MARK: BUTTON
            
            Button(action: {
                //MARK: NEED HELP ACTION
            }, label: {
                HStack{
                    Spacer()
                    Text("Need Help?")
                        .font(.custom("DMSans-Bold", size: CGFloat(buttonFontSize)))
                        .foregroundColor(Color("FF5A60"))
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                    Spacer()
                }
                .cornerRadius(50)
                .overlay(RoundedRectangle(cornerRadius: 50).stroke(Color.red, lineWidth: 1))
                .padding()
            })
        }
    }
    
    var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.black)
                //.bold(true)
        }
    }
    
    
    func formatNumber(_ number: Double) -> String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 2
            
            return formatter.string(from: NSNumber(value: number)) ?? ""
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }

}

struct OrderHistoryDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        OrderHistoryDetailsView(order: OrdersModel(id: "12345", paymentIntentId: "payment123", restaurantId: "rest123", status: "COMPLETED", timestamp: Date(), userId: "user123", amount: 10, orderNumber: 33333, address: "123 ABC Street"))
    }
}



