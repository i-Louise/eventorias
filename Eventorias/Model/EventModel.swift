//
//  EventModel.swift
//  Eventorias
//
//  Created by Louise Ta on 28/11/2024.
//

import Foundation

struct EventModel: Identifiable, Decodable {
    let id: String
    let title: String
    let address: String
    let description: String
    let imageUrl: String
    let dateTime: Date
    let category: String
    let profilePictureUrl: String
}
