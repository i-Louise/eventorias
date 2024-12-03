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
    private var db = Firestore.firestore()
    private let eventService = EventService()
    
    func onActionFetchingEvents(sortedByDate descending: Bool? = nil, category: String? = nil) {
        Task {
            do {
               events = try await eventService.fetchEvents(sortedByDate: descending, category: category)
            } catch {
                errorMessage = "Error fetching events: \(error.localizedDescription)"
            }
        }
    }
}

