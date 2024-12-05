//
//  AddEventTests.swift
//  EventoriasTests
//
//  Created by Louise Ta on 04/12/2024.
//

import XCTest
import Combine
@testable import Eventorias

final class AddEventTests: XCTestCase {
    private var mockAddEventService: MockAddEventService!
    private var mockImageUploader: MockImageUploader!
    private var viewModel: CreateEventViewModel!
    
    override func setUp() {
        super.setUp()
        mockAddEventService = MockAddEventService()
        mockImageUploader = MockImageUploader()
        viewModel = CreateEventViewModel(addService: mockAddEventService, imageUploader: mockImageUploader, onCreationSucceed: {
            print("Creation succeeded")
        })
    }
    override func tearDown() {
        mockAddEventService = nil
        viewModel = nil
    }
    
    func test_GivenAnEmptyTitle_WhenOnCreationActionIsCalled_ReturnsAlertMessage() {
        // Given & When
        viewModel.onCreationAction(address: "123 rue des arts", category: .art, date: Date(), description: "Art event", image: Data(), title: "")
        
        // Then
        XCTAssertEqual(viewModel.alertMessage, "Please write a title for your event")
        XCTAssertFalse(mockAddEventService.addEventCalled)
    }
    
    func test_GivenAnEmptyAddress_WhenOnCreationActionIsCalled_ReturnsAlertMessage() {
        // Given & When
        viewModel.onCreationAction(address: "", category: .art, date: Date(), description: "Art event", image: Data(), title: "Night in the museum")
        
        // Then
        XCTAssertEqual(viewModel.alertMessage, "Address not recognized")
        XCTAssertFalse(mockAddEventService.addEventCalled)
    }
    
    func test_GivenValidInputs_WhenOnCreationActionIsCalled_ThenCallsAddEventService() {
        // Given & When
        let expectation = XCTestExpectation(description: "Add event call expectation")

        viewModel.onCreationAction(address: "123 rue des arts", category: .art, date: Date(), description: "Art event", image: Data(), title: "Night in the museum")
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.mockImageUploader.imageUploaded)
            XCTAssertTrue(self.mockAddEventService.addEventCalled)
            XCTAssertNil(self.viewModel.alertMessage)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_GivenValidInputs_WhenOnCreationActionIsCalled_AndAnErrorOccured_ThenReturnsAlertMessage() {
        // Given & When
        let expectation = XCTestExpectation(description: "Add event failure expectation")
        
        mockAddEventService.shouldSucceedAddEvent = false
        viewModel.onCreationAction(address: "123 rue des arts", category: .art, date: Date(), description: "Art event", image: Data(), title: "Night in the museum")
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.mockAddEventService.addEventCalled)
            XCTAssertEqual(self.viewModel.alertMessage, "An error occur while creating your event")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_GivenValidInputs_WhenOnCreationIsCalled_AndAnErrorOccuredDuringImageUpload_ThenReturnsAlertMessage() {
        
        // Given
        let expectation = XCTestExpectation(description: "Add event failure expectation")
        
        mockAddEventService.shouldSucceedAddEvent = true
        mockImageUploader.shouldFail = true
        
        // When
        viewModel.onCreationAction(address: "123 rue des arts", category: .art, date: Date(), description: "Art event", image: Data(), title: "Night in the museum")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.viewModel.alertMessage, "Image upload failed")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
}
