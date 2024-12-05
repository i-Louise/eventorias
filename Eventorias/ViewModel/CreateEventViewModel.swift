//
//  CreateEventViewModel.swift
//  Eventorias
//
//  Created by Louise Ta on 21/11/2024.
//

import Foundation

class CreateEventViewModel: ObservableObject {
    @Published var alertMessage: String? = nil
    private let addService: AddEventProtocol
    var onCreationSucceed: (() -> Void)
    private let imageUploader: ImageUploaderProtocol
    
    init(addService: AddEventProtocol, imageUploader: ImageUploaderProtocol = ImageUploader(), onCreationSucceed: @escaping () -> Void) {
        self.addService = addService
        self.imageUploader = imageUploader
        self.onCreationSucceed = onCreationSucceed
    }
    
    func onCreationAction(address: String, category: EventCategory, date: Date, description: String, image: Data, title: String) {
        alertMessage = nil
        if title.isEmpty {
            alertMessage = "Please write a title for your event"
        } else if address.isEmpty {
            alertMessage = "Address not recognized"
        } else {
            createEvent(address: address, category: category.rawValue, date: date, description: description, image: image, title: title)
        }
    }
    
    private func createEvent(address: String, category: String, date: Date, description: String, image: Data, title: String) {
        imageUploader.uploadImage(path: "events/images/\(UUID().uuidString).jpg", image: image) { imageUrl, error in
            if let error = error {
                        print("Image upload failed: \(error.localizedDescription)")
                        self.alertMessage = "Image upload failed"
                        return
                    }
                    guard let imageUrl = imageUrl else {
                        print("Image URL is nil")
                        self.alertMessage = "Image upload failed"
                        return
                    }
            let newEvent = EventRequestModel(title: title, description: description, dateTime: date, address: address, imageUrl: imageUrl, category: category)
            Task {
                await self.addService.addEvent(event: newEvent) { error in
                    if let error = error {
                        print("Error creating event: \(error.localizedDescription)")
                        self.alertMessage = "An error occur while creating your event"
                        return
                    }
                    DispatchQueue.main.async {
                        self.onCreationSucceed()
                    }
                }
            }
        }
    }
}
