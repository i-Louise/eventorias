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

class AddEventService: AddEventProtocol, ObservableObject {
    private var db = Firestore.firestore()
    
    func addEvent(event: Event, completion: @escaping ((any Error)?) -> Void) {
        Task {
            do {
                guard let userId = Auth.auth().currentUser?.uid else {
                    completion(NSError(domain: "User not logged in", code: 1, userInfo: nil))
                    return
                }
                let ref = try await db.collection("Event").addDocument(data: [
                    "Address": event.address,
                    "Category": event.category,
                    "Date": event.dateTime,
                    "Description": event.description,
                    "Picture": event.picture,
                    "Title": event.title,
                    "userId": userId
                ])
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
