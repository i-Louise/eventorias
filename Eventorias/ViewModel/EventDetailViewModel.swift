//
//  EventDetailViewModel.swift
//  Eventorias
//
//  Created by Louise Ta on 20/11/2024.
//

import Foundation
import CoreLocation
import Firebase
import FirebaseFirestore

class EventDetailViewModel: ObservableObject {
    @Published var markerCoordinate = CLLocationCoordinate2D(latitude: 41.693333, longitude: 44.801667)
    private var db = Firestore.firestore()
    
//    func fetchUserProfilePicture(userId: String) {
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

