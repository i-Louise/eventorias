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
    @Published var errorMessage: String? = nil
    @Published var searchText: String = ""
    @Published var selectedCategory: String? = nil
    @Published var isLoading: Bool = false
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
        isLoading = true
        Task {
            do {
                let fetchedEvents = try await eventService.fetchEvents(sortedByDate: descending, category: category)
                DispatchQueue.main.async {
                    self.events = fetchedEvents
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "An error has occurred, please try again later"
                    self.isLoading = false
                }
            }
        }
    }
}

