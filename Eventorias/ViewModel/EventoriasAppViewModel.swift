//
//  EventoriasAppViewModel.swift
//  Eventorias
//
//  Created by Louise Ta on 18/11/2024.
//

import Foundation

class EventoriasAppViewModel: ObservableObject {
    @Published var isLogged: Bool
    
    init() {
        isLogged = false
    }
    
    var authenticationViewModel: AuthenticationViewModel {
        AuthenticationViewModel() {
            self.isLogged = true
        }
    }
}
