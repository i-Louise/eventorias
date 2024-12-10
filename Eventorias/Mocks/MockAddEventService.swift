//
//  MockAddEventService.swift
//  EventoriasTests
//
//  Created by Louise Ta on 04/12/2024.
//

import Foundation

class MockAddEventService: AddEventProtocol {    
    var addEventCalled = false
    var shouldSucceedAddEvent = true
    var capturedEvent: EventRequestModel?
    
    func addEvent(
        event: EventRequestModel,
        completion: @escaping (Error?) -> Void
    ) async {
        addEventCalled = true
        capturedEvent = event
        
        if shouldSucceedAddEvent {
            completion(nil)
        } else {
            completion(NSError(domain: "MockEventService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Add event failed"]))
        }
    }
}
