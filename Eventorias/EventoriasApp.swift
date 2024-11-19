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
import FirebaseFirestore

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
    @StateObject var viewModel = EventoriasAppViewModel()
    
    var body: some Scene {
        WindowGroup {
            if viewModel.isLogged {
                EventListView(viewModel: EventListViewModel())
            } else {
                SignInView(viewModel: AuthenticationViewModel() {
                    viewModel.isLogged = true
                })
            }
        }
    }
}
