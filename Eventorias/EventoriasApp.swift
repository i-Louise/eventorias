//
//  EventoriasApp.swift
//  Eventorias
//
//  Created by Louise Ta on 09/11/2024.
//

import SwiftUI
import Firebase

@main
struct EventoriasApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            SignInView()
        }
    }
}
