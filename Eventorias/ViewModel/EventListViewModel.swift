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
    
//    var filteredEvents: [EventResponseModel] {
//        guard !searchText.isEmpty else { return events }
//        return events.filter { event in
//            event.title.lowercased().contains(searchText.lowercased())
//        }
//    }
    
    func fetchEvents() {
        Task {
            do {
                let eventSnapshot = try await db.collection("events").getDocuments()
                let fetchedEvents: [EventResponseModel] = try eventSnapshot.documents.compactMap { document in
                    try document.data(as: EventResponseModel.self)
                }
                
                var eventWithUser: [EventModel] = []
                for event in fetchedEvents {
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
                
                DispatchQueue.main.async {
                    self.events = eventWithUser
                    print("fetch events success")
                }
            } catch {
                errorMessage = "Error fetching events: \(error.localizedDescription)"
                print(errorMessage ?? "Unknown error")
            }
        }
    }
    
//    func fetchUserInfo(userId: String) {
//        Task {
//            do {
//                let document = try await db.collection("users").document(userId).getDocument()
//                if let profilePictureUrl = document["profilePicture"] as? String {
//                    self.profilePictureUrl = profilePictureUrl
//                } else {
//                    self.profilePictureUrl = ""
//                }
//            } catch {
//                print("Error fetching profile picture: \(error.localizedDescription)")
//            }
//        }
//    }
    
    func getAllEventsSortedByDate(descending: Bool) async throws -> [EventResponseModel] {
        let snapshot = try await db.collection("events")
            .order(by: "date", descending: descending)
            .getDocuments()
        
        return snapshot.documents.compactMap { document in
            try? document.data(as: EventResponseModel.self)
        }
    }
}

