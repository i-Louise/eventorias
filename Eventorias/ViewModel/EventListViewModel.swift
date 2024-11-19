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
    @Published var events = [Event]()
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    @Published var selectedCategory: String? = nil
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
        
    var filteredEvents: [Event] {
        guard !searchText.isEmpty else { return events }
        return events.filter { event in
            event.title.lowercased().contains(searchText.lowercased())
        }
    }

    func fetchEvents() {
        Task {
            do {
                let querySnapShot = try await db.collection("Event").getDocuments()
                let events: [Event] = try querySnapShot.documents.compactMap { document in
                    try document.data(as: Event.self)
                }
                
                DispatchQueue.main.async {
                    self.events = events
                }
                
                for event in events {
                    print("Event ID: \(event.id ?? "No ID"), Title: \(event.title)")
                }
            } catch let error as NSError {
                print("Error fetching events: \(error.localizedDescription)")
            }
        }
    }
    
    func getAllEventsSortedByDate(descending: Bool) async throws -> [Event] {
        let snapshot = try await db.collection("Event")
            .order(by: "Date", descending: descending)
            .getDocuments()
        
        return snapshot.documents.compactMap { document in
            try? document.data(as: Event.self)
        }
    }
    
    enum FilterOption: String, CaseIterable {
        case noFilter
        case priceHigh
        case priceLow
    }
    
    func filterSelected(option: FilterOption) async throws {
        switch option {
        case .noFilter:
            fetchEvents()
        case .priceHigh:
            self.events = try await getAllEventsSortedByDate(descending: true)
        case .priceLow:
            self.events = try await getAllEventsSortedByDate(descending: false)
        }
    }
}
