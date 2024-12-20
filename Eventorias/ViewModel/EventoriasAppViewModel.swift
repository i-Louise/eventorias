//
//  EventoriasAppViewModel.swift
//  Eventorias
//
//  Created by Louise Ta on 18/11/2024.
//

import Foundation

class EventoriasAppViewModel: ObservableObject {
    @Published var isLogged: Bool
    let authenticationService: AuthenticationServiceProtocol
    let imageUploader: ImageUploaderProtocol
    let eventService: EventServiceProtocol
    let addEventService: AddEventProtocol
    let userService: UserServiceProtocol
    
    init(
        isLogged: Bool,
        authenticationService: AuthenticationServiceProtocol,
        imageUploader: ImageUploaderProtocol,
        eventService: EventServiceProtocol,
        addEventService: AddEventProtocol,
        userService: UserServiceProtocol
    ) {
        self.isLogged = isLogged
        self.authenticationService = authenticationService
        self.imageUploader = imageUploader
        self.eventService = eventService
        self.addEventService = addEventService
        self.userService = userService
    }
    
    var authenticationViewModel: SignInViewModel {
        SignInViewModel(
            authenticationService: authenticationService,
            imageUploader: imageUploader
        ) {
            self.isLogged = true
        }
    }
    
    var eventListViewModel: EventListViewModel {
        return EventListViewModel(
            eventService: eventService,
            addEventService: addEventService,
            imageUploader: imageUploader
        )
    }
    
    var userProfileViewModel: UserProfileViewModel {
        return UserProfileViewModel(
            userService: userService
        )
    }
}
