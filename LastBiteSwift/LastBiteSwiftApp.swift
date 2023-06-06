//
//  LastBiteSwiftApp.swift
//  LastBiteSwift
//
//  Created by Jay Uppaluri on 2/7/23.
//

import SwiftUI
import FirebaseCore
import Stripe

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
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
           let publishableKey = dict["StripePublishableKey"] as? String {
            STPAPIClient.shared.publishableKey = publishableKey
        } else {
            print("Failed to load configuration from \(configFileName).plist")
        }
      FirebaseApp.configure()
        

    return true
  }
}

@main
struct LastBiteSwiftApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        let userService = UserService()
        let paymentService = PaymentService()
        WindowGroup {
            RootView()
                .environmentObject(userService)
                .environmentObject(paymentService)
        }
    }
}
