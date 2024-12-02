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
    @Published var events: [EventModel] = []
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    @Published var selectedCategory: String? = nil
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?

    func fetchEvents(sortedByDate descending: Bool? = nil, category: String? = nil) {
        Task {
            do {
                let fetchedEvents = try await fetchEventDocuments(sortedByDate: descending, category: category)
                let eventsWithUserDetails = try await fetchUserDetails(for: fetchedEvents)
                DispatchQueue.main.async {
                    self.events = eventsWithUserDetails
                    print("Fetch events success: \(self.events.count)")
                }
            } catch {
                errorMessage = "Error fetching events: \(error.localizedDescription)"
                print(errorMessage ?? "Unknown error")
            }
        }
    }

    private func fetchEventDocuments(sortedByDate descending: Bool?, category: String?) async throws -> [EventResponseModel] {
        var query: Query = db.collection("events")
        
        if let descending = descending {
            query = query.order(by: "dateTime", descending: descending)
        }
        if let category = category, category != "All" {
                query = query.whereField("category", isEqualTo: category)
            }
        
        let eventSnapshot = try await query.getDocuments()
        return try eventSnapshot.documents.compactMap { document in
            try document.data(as: EventResponseModel.self)
        }
    }

    private func fetchUserDetails(for events: [EventResponseModel]) async throws -> [EventModel] {
        var eventWithUser: [EventModel] = []
        
        for event in events {
            let userSnapshot = try await db.collection("users").document(event.userId).getDocument()
            if let profilePictureUrl = userSnapshot["profilePicture"] as? String, let eventId = event.id {
                let combinedModel = EventModel(
                    id: eventId,
                    title: event.title,
                    address: event.address,
                    description: event.description,
                    imageUrl: event.imageUrl,
                    dateTime: event.dateTime,
                    category: event.category,
                    profilePictureUrl: profilePictureUrl
                )
                eventWithUser.append(combinedModel)
            }
        }
        return eventWithUser
    }
}

