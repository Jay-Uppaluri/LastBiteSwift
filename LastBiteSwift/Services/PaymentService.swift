import StripePaymentSheet
import SwiftUI
import FirebaseAuth
import Combine
import Dispatch

class PaymentService: ObservableObject {
    var backendCheckoutUrl: URL?
    @Published var paymentSheet: PaymentSheet?
    @Published var paymentResult: PaymentSheetResult?

    private var currentRestaurantId: String?
    private var paymentSheetPreparation: AnyCancellable?
    private var paymentIntentClientSecret: String?
    private var customerId: String?
    private var customerEphemeralKeySecret: String?

    init() {
        let configFileName: String
        #if DEBUG
        configFileName = "Config-Debug"
        #elseif STAGING
        configFileName = "Config-Staging"
        #else
        configFileName = "Config-Release"
        #endif

        if let path = Bundle.main.path(forResource: configFileName, ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject],
           let publishableKey = dict["StripePublishableKey"] as? String,
           let backendCheckoutUrlString = dict["BackendCheckoutUrl"] as? String,
           let backendCheckoutUrl = URL(string: backendCheckoutUrlString) {
            STPAPIClient.shared.publishableKey = publishableKey
            self.backendCheckoutUrl = backendCheckoutUrl
        } else {
            print("Failed to load configuration from \(configFileName).plist")
        }
    }

    func preparePaymentSheet(restaurantId: String, completion: @escaping () -> Void) {
        guard let backendCheckoutUrl = backendCheckoutUrl else {
            print("Backend checkout URL is not set")
            return
        }
        let userId = AuthenticationManager.shared.getUserId()
        let paymentData = Payment(amount: 499, userId: userId!, restaurantId: restaurantId, orderType: "vegetarian")
        
        Auth.auth().currentUser?.getIDToken(completion: { (idToken, error) in
            guard let idToken = idToken else {
                print("error in retrieving current user IDToken")
                return
            }
            
            var request = URLRequest(url: backendCheckoutUrl)
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
                DispatchQueue.main.async {
                    var configuration = PaymentSheet.Configuration()
                    configuration.merchantDisplayName = "Vinny's Pizzeria and Winery"
                    configuration.customer = .init(id: customerId, ephemeralKeySecret: customerEphemeralKeySecret)
                    configuration.allowsDelayedPaymentMethods = true

                    self.paymentSheet = PaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret, configuration: configuration)
                    completion()
                }
            })
            task.resume()
        })
    }




    func onPaymentCompletion(result: PaymentSheetResult) {
        self.paymentResult = result
        self.paymentSheet = nil
        self.paymentIntentClientSecret = nil
        self.customerId = nil
        self.customerEphemeralKeySecret = nil
        
        if case .completed = result {
            onPaymentSuccess?()
        }
    }
    




    

    var onPaymentSuccess: (() -> Void)?


    func presentPaymentSheet() {
        guard let paymentSheet = self.paymentSheet else { return }

        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
           let rootViewController = scene.windows.first?.rootViewController {
               
            // Dismiss the currently presented view controller if there is one
            if let presentedViewController = rootViewController.presentedViewController {
                presentedViewController.dismiss(animated: false) {
                    paymentSheet.present(from: rootViewController) { result in
                        self.onPaymentCompletion(result: result)
                    }
                }
            } else {
                paymentSheet.present(from: rootViewController) { result in
                    self.onPaymentCompletion(result: result)
                }
            }
        }
    }




    

    
    
}




