//
//  EventoriasApp.swift
//  Eventorias
//
//  Created by Louise Ta on 09/11/2024.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct EventoriasApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @ObservedObject var authenticationService: AuthenticationService = AuthenticationService()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if authenticationService.isAuthenticated {
                    EventListView()
                } else {
                    SignInView(viewModel: AuthenticationViewModel())
                }
            }
        }
    }
}
