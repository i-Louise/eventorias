//
//  EventServiceProtocol.swift
//  Eventorias
//
//  Created by Louise Ta on 03/12/2024.
//

import Foundation

protocol EventServiceProtocol {
    func fetchEvents(sortedByDate descending: Bool?, category: String?) async throws -> [EventModel]
    func fetchEventDocuments(sortedByDate descending: Bool?, category: String?) async throws -> [EventResponseModel]
    func enrichEventsWithUserDetails(for events: [EventResponseModel]) async throws -> [EventModel]
}
