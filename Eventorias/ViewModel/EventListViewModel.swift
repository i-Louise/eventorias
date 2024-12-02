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
    
    func fetchEvents(sortedByDate descending: Bool? = nil, category: String? = nil) {
        Task {
            do {
                var query: Query = db.collection("events")
                
                if let descending = descending {
                    query = query.order(by: "dateTime", descending: descending)
                }
                
                let eventSnapshot = try await query.getDocuments()
                let fetchedEvents: [EventResponseModel] = try eventSnapshot.documents.compactMap { document in
                    try document.data(as: EventResponseModel.self)
                }
                
                var eventWithUser: [EventModel] = []
                for event in fetchedEvents {
                    if let category = category, event.category != category {
                        continue
                    }
                    
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
    
}

