//
//  MockEventService.swift
//  EventoriasTests
//
//  Created by Louise Ta on 04/12/2024.
//

import Foundation
@testable import Eventorias

class MockEventService: EventServiceProtocol {
    var eventsWithUserDetails: [EventModel] = []
    var events: [EventResponseModel] = []
    var shouldSucceed = true
    
    func fetchEvents(sortedByDate descending: Bool?, category: String?) async throws -> [Eventorias.EventModel] {
        if shouldSucceed {
            return eventsWithUserDetails
        } else {
            throw EventServiceError.unknownError
        }
    }
    
    func fetchEventDocuments(sortedByDate descending: Bool?, category: String?) async throws -> [Eventorias.EventResponseModel] {
        if shouldSucceed {
            return events
        } else {
            throw EventServiceError.unknownError
        }
    }
    
    func enrichEventsWithUserDetails(for events: [Eventorias.EventResponseModel]) async throws -> [Eventorias.EventModel] {
        if shouldSucceed {
            return eventsWithUserDetails
        } else {
            throw EventServiceError.unknownError
        }
    }
}
