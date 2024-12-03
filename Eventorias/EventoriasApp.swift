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
import GoogleMaps
import GooglePlaces

class AppDelegate: NSObject, UIApplicationDelegate {
    
  let apiKey = "AIzaSyBR3QC4KWiC1WXUis2sRqYRgPvFSoGFrCM"
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    GMSServices.provideAPIKey("AIzaSyBR3QC4KWiC1WXUis2sRqYRgPvFSoGFrCM")
    GMSPlacesClient.provideAPIKey("AIzaSyBR3QC4KWiC1WXUis2sRqYRgPvFSoGFrCM")
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
                MainTabView()
            } else {
                SignInView(viewModel: AuthenticationViewModel() {
                    viewModel.isLogged = true
                })
            }
        }
    }
}

struct MainTabView: View {
    
    var body: some View {
        TabView {
            EventListView(viewModel: EventListViewModel())
                .tabItem {
                    Label("Events", systemImage: "calendar")
                }
            UserProfileView(viewModel: UserProfileViewModel())
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .accentColor(.customRed)
    }
}
