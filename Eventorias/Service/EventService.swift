//
//  EventService.swift
//  Eventorias
//
//  Created by Louise Ta on 03/12/2024.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class EventService: EventServiceProtocol {
    private let db = Firestore.firestore()
    
    func fetchEvents(sortedByDate descending: Bool?, category: String?) async throws -> [EventModel] {
        do {
            let fetchedEvents = try await fetchEventDocuments(sortedByDate: descending, category: category)
            let eventsWithUserDetails = try await enrichEventsWithUserDetails(for: fetchedEvents)
            return eventsWithUserDetails
        } catch {
            print("Failed to fetch events: \(error.localizedDescription)")
            throw EventServiceError.unknownError
        }
    }
    
    func fetchEventDocuments(sortedByDate descending: Bool?, category: String?) async throws -> [EventResponseModel] {
        var query: Query = db.collection("events")
        
        if let descending = descending {
            query = query.order(by: "dateTime", descending: descending)
        }
        if let category = category, category != "All" {
            query = query.whereField("category", isEqualTo: category)
        }
        
        do {
            let eventSnapshot = try await query.getDocuments()
            return try eventSnapshot.documents.compactMap { document in
                try document.data(as: EventResponseModel.self)
            }
        } catch {
            print("Failed to order and fetch events: \(error.localizedDescription)")
            throw EventServiceError.networkError(error)
        }
    }
    
    func enrichEventsWithUserDetails(for events: [EventResponseModel]) async throws -> [EventModel] {
        var eventWithUser: [EventModel] = []
        
        for event in events {
            do {
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
                } else {
                    throw EventServiceError.dataParsingError
                }
            } catch {
                throw EventServiceError.networkError(error)
            }
        }
        return eventWithUser
    }
}

