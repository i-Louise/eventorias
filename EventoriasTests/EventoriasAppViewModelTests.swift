//
//  EventoriasAppViewModelTests.swift
//  EventoriasTests
//
//  Created by Louise Ta on 05/12/2024.
//

import XCTest
@testable import Eventorias

final class EventoriasAppViewModelTests: XCTestCase {
    
    func test_GivenAuthenticationViewModel_WhenNoLogin_ThenEnsureIsLoggedIsFalse() {
        let underTest = EventoriasAppViewModel()
        let authenticationViewModel = underTest.authenticationViewModel
        
        XCTAssertFalse(underTest.isLogged)
    }
    
    func test_GivenAuthenticationViewModel_WhenLoginSucceeds_ThenEnsureIsLoggedIsTrue() {
        let underTest = EventoriasAppViewModel()
        let authenticationViewModel = underTest.authenticationViewModel
        
        authenticationViewModel.onLoginSucceed()
        
        XCTAssertTrue(underTest.isLogged)
    }
}
