import StripePaymentSheet
import SwiftUI
import FirebaseAuth

class PaymentService: ObservableObject {
    let backendCheckoutUrl = URL(string: "https://us-central1-lastbite-907b1.cloudfunctions.net/paymentSheet")!
    @Published var paymentSheet: PaymentSheet?
    @Published var paymentResult: PaymentSheetResult?

    func preparePaymentSheet(restaurantId: String) {
        let userId = AuthenticationManager.shared.getUserId()
        let paymentData = Payment(amount: 499, userId: userId!, restaurantId: restaurantId, orderType: "vegetarian")
        
        Auth.auth().currentUser?.getIDToken(completion: { (idToken, error) in
            guard let idToken = idToken else {
                print("error in retrieving current user IDToken")
                return
            }
            
            var request = URLRequest(url: self.backendCheckoutUrl)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")
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
                configuration.allowsDelayedPaymentMethods = true

                DispatchQueue.main.async {
                    self.paymentSheet = PaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret, configuration: configuration)
                }
            })
            task.resume()
        })
    }
    
    func onPaymentCompletion(result: PaymentSheetResult) {
        self.paymentResult = result
        self.paymentSheet = nil
    }
}

