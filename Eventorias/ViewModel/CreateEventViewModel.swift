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
    
    func onCreationAction(address: String, category: EventCategory, date: Date, description: String, image: Data, title: String) {
        alertMessage = nil
        if title.isEmpty {
            alertMessage = "Title must be at least 2 characters long"
        } else if address.isEmpty {
            alertMessage = "Address not recognized"
        } else {
            createEvent(address: address, category: category.rawValue, date: date, description: description, image: image, title: title)
        }
    }
    
    private func createEvent(address: String, category: String, date: Date, description: String, image: Data, title: String) {
        ImageUploader.uploadImage(path: "events/images/\(UUID().uuidString).jpg", image: image) { imageUrl in
            let newEvent = EventRequestModel(title: title, description: description, dateTime: date, address: address, imageUrl: imageUrl, category: category)
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
