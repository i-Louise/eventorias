//
//  CreateEventViewModel.swift
//  Eventorias
//
//  Created by Louise Ta on 21/11/2024.
//

import Foundation

class CreateEventViewModel: ObservableObject {
    @Published var alertMessage: String? = nil
    @Published var showingAlert = false
    @Published var titleErrorMessage: String? = nil
    @Published var addressErrorMessage: String? = nil
    @Published var isLoading: Bool = false
    private let addService: AddEventProtocol
    private let imageUploader: ImageUploaderProtocol
    @Published var onCreationSucceed: (() -> Void)
    
    init(addService: AddEventProtocol, imageUploader: ImageUploaderProtocol, onCreationSucceed: @escaping () -> Void) {
        self.addService = addService
        self.imageUploader = imageUploader
        self.onCreationSucceed = onCreationSucceed
    }
    
    func onCreationAction(address: String, category: EventCategory, date: Date, description: String, image: Data, title: String, onSuccess: @escaping () -> Void, onFailure: @escaping (String) -> Void) {
        alertMessage = nil
        if title.isEmpty {
            alertMessage = "Please write a title for your event"
        } else if address.isEmpty {
            alertMessage = "Address not recognized"
        } else {
            createEvent(address: address, category: category.rawValue, date: date, description: description, image: image, title: title, onSuccess: onSuccess, onFailure: onFailure)
        }
    }
    
    private func createEvent(
        address: String,
        category: String,
        date: Date,
        description: String,
        image: Data,
        title: String,
        onSuccess: @escaping () -> Void,
        onFailure: @escaping (String) -> Void
    ) {
        isLoading = true
        imageUploader.uploadImage(path: "events/images/\(UUID().uuidString).jpg", image: image) { imageUrl, error in
            if let error = error {
                print("Image upload failed: \(error.localizedDescription)")
                self.isLoading = false
                self.alertMessage = "Image upload failed"
                onFailure(self.alertMessage ?? "")
                return
            }
            guard let imageUrl = imageUrl else {
                print("Image URL is nil")
                self.isLoading = false
                self.alertMessage = "Image upload failed"
                onFailure(self.alertMessage ?? "")
                return
            }
            let newEvent = EventRequestModel(title: title, description: description, dateTime: date, address: address, imageUrl: imageUrl, category: category)
            Task {
                await self.addService.addEvent(event: newEvent) { error in
                    if error != nil {
                        self.alertMessage = "An error occur while creating your event"
                        onFailure(self.alertMessage ?? "")
                        self.showingAlert = true
                        self.isLoading = false
                        return
                    }
                    DispatchQueue.main.async {
                        onSuccess()
                        self.isLoading = false
                    }
                }
            }
        }
    }
}
