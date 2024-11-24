//
//  CreateEventViewModel.swift
//  Eventorias
//
//  Created by Louise Ta on 21/11/2024.
//

import Foundation

class CreateEventViewModel: ObservableObject {
    @Published var alertMessage: String? = nil
    private let addService: AddEventService
    let onCreationSucceed: (() -> ())
    
    init(addService: AddEventService, _ callback: @escaping () -> ()) {
        self.addService = addService
        self.onCreationSucceed = callback
    }
    
    func onCreationAction(address: String, category: EventCategory, date: Date, description: String, picture: Data, title: String) {
        alertMessage = nil
        if title.isEmpty {
            alertMessage = "Title must be at least 2 characters long"
        } else if address.isEmpty {
            alertMessage = "Address not recognized"
        } else {
            createEvent(address: address, category: category, date: date, description: description, picture: picture, title: title)
        }
    }
    
    private func createEvent(address: String, category: EventCategory, date: Date, description: String, picture: Data, title: String) {
        ImageUploader.uploadImage(path: "/event_pictures/", image: picture) { imageUrl in
            let newEvent = EventRequestModel(title: title, description: description, dateTime: date, address: address, pictureUrl: imageUrl, category: category)
            Task {
                await self.addService.addEvent(event: newEvent) { error in
                    if let error = error {
                        print("Error creating event: \(error.localizedDescription)")
                        return
                    }
                }
            }
        }
    }
}
