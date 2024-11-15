//
//  EventModel.swift
//  Eventorias
//
//  Created by Louise Ta on 12/11/2024.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

struct Event: Codable, Identifiable {
    @DocumentID var id: String?
    
    var title: String
    var description: String
    var date: Date
    var time: String
    var address: String
    var category: Category
    
    var userId = String()
}

enum Category: String, CaseIterable, Codable  {
    case musicFestival = "Music festival"
    case artExhibit = "Art exhibition"
    case techConference = "Tech conference"
    case foodFair = "Food fair"
    case bookSigning = "Book signing"
    case filmScreening = "Film screening"
    case charityRun = "Charity run"
}
