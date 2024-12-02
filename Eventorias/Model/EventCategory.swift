//
//  EventCategory.swift
//  Eventorias
//
//  Created by Louise Ta on 24/11/2024.
//

enum EventCategory: String, CaseIterable, Codable {
    case art = "Art"
    case tech = "Tech"
    case gastronomy = "Gastronomy"
    case litterature = "Litterature"
    case movie = "Movie"
    case caritative = "Caritative"
    case other = "Other"
    
    case all = "All"
    
    static var allCasesForPicker: [EventCategory] {
        return EventCategory.allCases.filter { $0 != .all }
    }
}
