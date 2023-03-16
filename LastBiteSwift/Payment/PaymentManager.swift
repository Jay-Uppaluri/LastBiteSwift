import StripePaymentSheet
import SwiftUI

class PaymentManager: ObservableObject {
  let backendCheckoutUrl = URL(string: "https://us-central1-lastbite-907b1.cloudfunctions.net/paymentSheet")!
 // Your backend endpoint
  @Published var paymentSheet: PaymentSheet?
  @Published var paymentResult: PaymentSheetResult?

  func preparePaymentSheet() {
      let paymentData = Payment(amount: 499)
      var request = URLRequest(url: backendCheckoutUrl)
      request.httpMethod = "POST"
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      request.httpBody = try? JSONEncoder().encode(paymentData)
      
    // MARK: Fetch the PaymentIntent and Customer information from the backend
    let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
      guard let data = data,
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
            let customerId = json["customer"] as? String,
            let customerEphemeralKeySecret = json["ephemeralKey"] as? String,
            let paymentIntentClientSecret = json["paymentIntent"] as? String,
            let self = self else {
        // Handle error
        return
      }

      STPAPIClient.shared.publishableKey = "pk_test_51Mm5YMJa42zn3jCLDGyMInDAgUBxKBCNjFLeqCdpSi2QTwZwKFahXKbvd23gHy18En2nS3eqCfthgRPNEZwxZy4V00chCbTmqB"
      // MARK: Create a PaymentSheet instance
      var configuration = PaymentSheet.Configuration()
      configuration.merchantDisplayName = "Vinny's Pizzeria and Winery"
      configuration.customer = .init(id: customerId, ephemeralKeySecret: customerEphemeralKeySecret)
      // Set `allowsDelayedPaymentMethods` to true if your business can handle payment methods
      // that complete payment after a delay, like SEPA Debit and Sofort.
      configuration.allowsDelayedPaymentMethods = true

      DispatchQueue.main.async {
        self.paymentSheet = PaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret, configuration: configuration)
      }
    })
    task.resume()
  }

  func onPaymentCompletion(result: PaymentSheetResult) {
      self.paymentResult = result
      self.paymentSheet = nil
  }
}

struct CheckoutView: View {
  @ObservedObject var model = PaymentManager()

  var body: some View {
    VStack {
      if let paymentSheet = model.paymentSheet {
        PaymentSheet.PaymentButton(
          paymentSheet: paymentSheet,
          onCompletion: { result in
            model.onPaymentCompletion(result: result)
            model.paymentSheet = nil
          }
        ) {
          Text("Buy")
        }
      } else if let result = model.paymentResult {
        switch result {
        case .completed:
          Text("Payment complete")
        case .failed(let error):
          Text("Payment failed: \(error.localizedDescription)")
        case .canceled:
          Text("Payment canceled.")
        }
          Button(action: {
              model.preparePaymentSheet()
              model.paymentSheet = nil
          }) {
              Text("Buy again")
          }
      } else {
        Text("Loading…")
      }
    }.onAppear { model.preparePaymentSheet() }
  }
}

