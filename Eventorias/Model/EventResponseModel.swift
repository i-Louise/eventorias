//
//  EventResponseModel.swift
//  Eventorias
//
//  Created by Louise Ta on 24/11/2024.
//

import Foundation

struct EventResponseModel: Decodable, Identifiable {
    var id: String?
    let title: String
    let address: String
    let description: String
    let picture: String
    let dateTime: Date
    let category: EventCategory
    let userId: String
}
