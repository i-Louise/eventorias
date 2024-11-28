//
//  EventRequestModel.swift
//  Eventorias
//
//  Created by Louise Ta on 12/11/2024.
//

import Foundation
import FirebaseFirestore

struct EventRequestModel {
//    @DocumentID var id: String?
    let title: String
    let description: String
    let dateTime: Date
    let address: String
    let imageUrl: String
    let category: String
}
