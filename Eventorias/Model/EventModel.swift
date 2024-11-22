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
    var dateTime: Date
    var address: String
    var picture: String
    var category: Category
    
    //var userId = String()
    
    enum CodingKeys: String, CodingKey {
        case id
        case title = "Title"
        case description = "Description"
        case dateTime = "Date"
        case address = "Address"
        case picture = "Picture"
        case category = "Category"
    }
    enum Category: String, CaseIterable, Codable  {
        case Art = "Art"
        case Tech = "Tech"
        case Gastronomy = "Gastronomy"
        case Litterature = "Litterature"
        case Movie = "Movie"
        case Caritative = "Caritative"
        case Other = "Other"
    }
}
