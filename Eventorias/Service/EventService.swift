//
//  EventService.swift
//  Eventorias
//
//  Created by Louise Ta on 03/12/2024.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class EventService: EventServiceProtocol {
    private let db = Firestore.firestore()

    func fetchEvents(
        sortedByDate descending: Bool?,
        category: String?
    )
    async throws -> [EventModel] {
        
        let fetchedEvents = try await fetchEventDocuments(sortedByDate: descending, category: category)
        let eventsWithUserDetails = try await fetchUserDetails(for: fetchedEvents)

        return eventsWithUserDetails
    }
    
    func fetchEventDocuments(
        sortedByDate descending: Bool?,
        category: String?
    )
    async throws -> [EventResponseModel] {
        
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
    
    func fetchUserDetails(
        for events: [EventResponseModel]
    )
    async throws -> [EventModel] {
        
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

