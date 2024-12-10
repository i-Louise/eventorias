//
//  EventListViewModelTests.swift
//  EventoriasTests
//
//  Created by Louise Ta on 03/12/2024.
//

import XCTest
import Combine
@testable import Eventorias

class EventListViewModelTests: XCTestCase {
    private var mockEventService: MockEventService!
    private var mockAddEventService: MockAddEventService!
    private var mockImageUploader: MockImageUploader!
    private var viewModel: EventListViewModel!
    
    override func setUp() {
        super.setUp()
        mockEventService = MockEventService()
        mockAddEventService = MockAddEventService()
        mockAddEventService.shouldSucceedAddEvent = true
        mockImageUploader = MockImageUploader()
        mockImageUploader.shouldFail = false
        viewModel = EventListViewModel(
            eventService: mockEventService,
            addEventService: mockAddEventService,
            imageUploader: mockImageUploader
        )
    }
    
    override func tearDown() {
        viewModel = nil
        mockEventService = nil
        mockAddEventService = nil
        mockImageUploader = nil
        super.tearDown()
    }
    
    func testFetchEvents_Success() {
        // Given
        mockEventService.eventsWithUserDetails = [
            EventModel(id: "fakeId", title: "Art Event", address: "123 Street", description: "An event", imageUrl: "http://example.com/image.jpg", dateTime: Date.now, category: "Art", profilePictureUrl: "http://example.com/image.jpg")
        ]
        
        var cancellable = Set<AnyCancellable>()
        
        let expectation = XCTestExpectation()
        viewModel.$events
            .sink { events in
                if !events.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellable)
        
        // When
        viewModel.onActionFetchingEvents(sortedByDate: true, category: "All")
        
        wait(for: [expectation], timeout: 1.0)
        
        // Then
        XCTAssertEqual(viewModel.events.count, 1)
    }
    
    func testFetchEvents_Failure() {
        // Given
        mockEventService.eventsWithUserDetails = [
            EventModel(id: "fakeId", title: "Art Event", address: "123 Street", description: "An event", imageUrl: "http://example.com/image.jpg", dateTime: Date.now, category: "Art", profilePictureUrl: "http://example.com/image.jpg")
        ]
        mockEventService.shouldSucceed = false
        
        var cancellable = Set<AnyCancellable>()
        
        let expectation = XCTestExpectation()
        viewModel.$events
            .sink { events in
                if events.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellable)
        
        // When
        viewModel.onActionFetchingEvents(sortedByDate: true, category: "All")
        
        wait(for: [expectation], timeout: 1.0)
        
        // Then
        XCTAssertTrue(viewModel.events.isEmpty)
        XCTAssertEqual(viewModel.errorMessage, "An error has occured, please try again later")
    }
}

