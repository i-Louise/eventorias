//
//  AddEventService.swift
//  Eventorias
//
//  Created by Louise Ta on 21/11/2024.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class AddEventService: AddEventProtocol {
    private let db = Firestore.firestore()
    
    func addEvent(event: EventRequestModel, completion: @escaping (Error?) -> Void) async {
        do {
            guard let userId = Auth.auth().currentUser?.uid else {
                completion(NSError(domain: "User not logged in", code: 1, userInfo: nil))
                return
            }
            try await db.collection("events").addDocument(data: [
                "address": event.address,
                "category": event.category,
                "dateTime": event.dateTime,
                "description": event.description,
                "imageUrl": event.imageUrl,
                "title": event.title,
                "userId": userId
            ])
            print("Event creation success")
            completion(nil)
        } catch {
            print(error.localizedDescription)
        }
    }
}
