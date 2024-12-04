//
//  EventServiceError.swift
//  Eventorias
//
//  Created by Louise Ta on 04/12/2024.
//

import Foundation

enum EventServiceError: Error {
    case documentNotFound
    case dataParsingError
    case networkError(Error)
    case unknownError
}
