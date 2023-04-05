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
      StripeAPI.defaultPublishableKey = "pk_test_51Mm5YMJa42zn3jCLDGyMInDAgUBxKBCNjFLeqCdpSi2QTwZwKFahXKbvd23gHy18En2nS3eqCfthgRPNEZwxZy4V00chCbTmqB"
      FirebaseApp.configure()
        

    return true
  }
}

@main
struct LastBiteSwiftApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        let userService = UserService()
        WindowGroup {
            HomeView()
                .environmentObject(userService)
        }
    }
}
