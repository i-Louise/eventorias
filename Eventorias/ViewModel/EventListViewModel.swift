//
//  EventListViewModel.swift
//  Eventorias
//
//  Created by Louise Ta on 13/11/2024.
//

import Foundation
import Combine
import Firebase
import FirebaseFirestore

class EventListViewModel: ObservableObject {
    @Published var events: [EventModel] = []
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    @Published var selectedCategory: String? = nil
    private let eventService: EventServiceProtocol
    private let addEventService: AddEventProtocol
    private let imageUploader: ImageUploaderProtocol
    
    init(eventService: EventServiceProtocol, addEventService: AddEventProtocol, imageUploader: ImageUploaderProtocol) {
        self.eventService = eventService
        self.addEventService = addEventService
        self.imageUploader = imageUploader
    }
    
    var createEventViewModel: CreateEventViewModel {
        return CreateEventViewModel(
            addService: addEventService,
            imageUploader: imageUploader,
            onCreationSucceed: {
                print("fetch events done")
            }
        )
    }
    
    func onActionFetchingEvents(sortedByDate descending: Bool? = nil, category: String? = nil) {
        Task {
            do {
                events = try await eventService.fetchEvents(sortedByDate: descending, category: category)
            } catch {
                errorMessage = "An error has occured, please try again later"
            }
        }
    }
}

