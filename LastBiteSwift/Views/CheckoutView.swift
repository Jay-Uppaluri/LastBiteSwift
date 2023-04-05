//import SwiftUI
//import StripePaymentSheet
//
//
//struct CheckoutView: View {
//  @ObservedObject var model = PaymentService()
//
//  var body: some View {
//    VStack {
//      if let paymentSheet = model.paymentSheet {
//        PaymentSheet.PaymentButton(
//          paymentSheet: paymentSheet,
//          onCompletion: { result in
//            model.onPaymentCompletion(result: result)
//            model.paymentSheet = nil
//          }
//        ) {
//          Text("Buy")
//        }
//      } else if let result = model.paymentResult {
//        switch result {
//        case .completed:
//          Text("Payment complete")
//        case .failed(let error):
//          Text("Payment failed: \(error.localizedDescription)")
//        case .canceled:
//          Text("Payment canceled.")
//        }
//          Button(action: {
//              model.preparePaymentSheet()
//              model.paymentSheet = nil
//          }) {
//              Text("Buy again")
//          }
//      } else {
//        Text("Loading…")
//      }
//    }.onAppear { model.preparePaymentSheet(restaurantId: <#String#>) }
//  }
//}
