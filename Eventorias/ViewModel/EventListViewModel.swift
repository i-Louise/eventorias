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

@MainActor
class EventListViewModel: ObservableObject {
    @Published var events: [EventResponseModel] = []
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    @Published var selectedCategory: String? = nil
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    var filteredEvents: [EventResponseModel] {
        guard !searchText.isEmpty else { return events }
        return events.filter { event in
            event.title.lowercased().contains(searchText.lowercased())
        }
    }
    
    func fetchEvents() {
        Task {
            do {
                let querySnapshot = try await db.collection("events").getDocuments()
                let fetchedEvents: [EventResponseModel] = try querySnapshot.documents.compactMap { document in
                    try document.data(as: EventResponseModel.self)
                }
                self.events = fetchedEvents
            } catch {
                errorMessage = "Error fetching events: \(error.localizedDescription)"
                print(errorMessage ?? "Unknown error")
            }
        }
    }
    
    func getAllEventsSortedByDate(descending: Bool) async throws -> [EventResponseModel] {
        let snapshot = try await db.collection("events")
            .order(by: "date", descending: descending)
            .getDocuments()
        
        return snapshot.documents.compactMap { document in
            try? document.data(as: EventResponseModel.self)
        }
    }
}

