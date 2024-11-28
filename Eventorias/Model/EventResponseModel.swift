//
//  EventResponseModel.swift
//  Eventorias
//
//  Created by Louise Ta on 24/11/2024.
//

import Foundation
import FirebaseFirestore

struct EventResponseModel: Decodable, Identifiable {
    @DocumentID var id: String?
    let title: String
    let address: String
    let description: String
    let imageUrl: String
    let dateTime: Date
    let category: String
    let userId: String
}
