//
//  OrderHistoryView.swift
//  cameronmotameni
//
//  Created by Aiden Seibel on 6/9/23.
//

import SwiftUI

struct OrderHistoryView: View {
    @Environment(\.presentationMode) var presentationMode
    var spacing: Double = 16.0
    var headingFontSize: Double = 16.0
    let userId = AuthenticationManager.shared.getUserId()
    @StateObject private var viewModel: OrderViewModel

    init() {
        let userId = AuthenticationManager.shared.getUserId() ?? ""
        _viewModel = StateObject(wrappedValue: OrderViewModel(userId: userId))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: spacing * 2){
                    VStack(alignment: .leading){
                        Text("Active Orders")
                            .font(.custom("DMSans-Bold", size: CGFloat(Float(headingFontSize))))

                        ForEach(viewModel.orders.filter { $0.status == "OPEN" || $0.status == "PROPOSED" || $0.status == "READY"}.sorted(by: { $0.timestamp > $1.timestamp })) { order in
                            MiniOrderView(order: order, isPastOrder: false)
                        }
                    }
                    VStack(alignment: .leading){
                        Text("Past Orders")
                            .font(.custom("DMSans-Bold", size: CGFloat(Float(headingFontSize))))

                        ForEach(viewModel.orders.filter { $0.status == "COMPLETED" }.sorted(by: { $0.timestamp > $1.timestamp })) { order in
                            MiniOrderView(order: order, isPastOrder: true)
                        }
                        Spacer()
                    }

                }
            }
            .padding(spacing)
        }
        .navigationBarTitle("Orders")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.black)
        }
    }
}


struct MiniOrderView: View {
    var order: OrdersModel
    var isPastOrder: Bool

    var body: some View {
        if isPastOrder {
            NavigationLink(destination: OrderHistoryDetailsView(order: order)) {
                miniOrderContent()
            }
        } else {
            miniOrderContent()
        }
    }

    private func miniOrderContent() -> some View {
        VStack(alignment: .leading) {
            HStack {
                Image("dominosLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.red, lineWidth: 2))
                    .padding(10)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Pizza Place")
                        .font(.custom("DMSans-Bold", size:14))
                        .foregroundColor(.black)
                    Text(formattedDate(from: order.timestamp))
                        .font(.custom("DMSans-Regular", size: 13))
                        .foregroundColor(.black)
                    Text("Standard Package x1")
                        .font(.custom("DMSans-Regular", size: 13))
                        .foregroundColor(.gray)
                }
                Spacer()

                if isPastOrder {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.black)
                        .padding(10)
                } else {
                    NavigationLink(destination: PaymentConfirmationView(order: order)) {
                        Text("View Code")
                            .font(.custom("DMSans-Medium", size: 13))
                            .foregroundColor(.black)
                            .padding(10)
                            .background(Color("FCFCFC"))
                            .cornerRadius(50)
                    }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                }
            }
            Divider()
                .opacity(0.50)
        }
    }

    private func formattedDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}





struct OrderHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        OrderHistoryView()
    }
}

