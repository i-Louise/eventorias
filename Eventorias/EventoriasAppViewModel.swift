//
//  EventoriasAppViewModel.swift
//  Eventorias
//
//  Created by Louise Ta on 18/11/2024.
//

import Foundation

class EventoriasAppViewModel: ObservableObject {
    @Published var isLogged: Bool
    let authenticationService: AuthenticationService
    
    init() {
        isLogged = false
        authenticationService = AuthenticationService()
    }
    var authenticationViewModel: AuthenticationViewModel {
        AuthenticationViewModel() {
            self.isLogged = true
        }
    }
}
