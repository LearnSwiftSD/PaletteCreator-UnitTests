//
//  XCUIElement+Wait.swift
//  PaletteCreatorUITests
//
//  Created by Dave Shu on 11/6/18.
//  Copyright © 2018 Dave Shu. All rights reserved.
//

import XCTest

extension XCUIElement {    
    func ensureExists(timeout: TimeInterval = 20, description: String = "") {
        XCTAssertEqual(waitUntilExists(timeout: timeout, description: description), .completed)
    }
    
    func ensureExistsFalse(timeout: TimeInterval = 20, description: String = "") {
        XCTAssertEqual(waitUntilExistsFalse(timeout: timeout, description: description), .completed)
    }

    func wait(for predicate: String, timeout: TimeInterval = 20, description: String = "") -> XCTWaiter.Result {
        let expectation = XCTNSPredicateExpectation(predicate: NSPredicate(format: predicate), object: self)
        expectation.expectationDescription = description
        return XCTWaiter().wait(for: [expectation], timeout: timeout)
    }
    
    func waitUntilExists(timeout: TimeInterval = 20, description: String = "") -> XCTWaiter.Result {
        return wait(for: "exists == true", timeout: timeout, description: description)
    }
    
    func waitUntilExistsFalse(timeout: TimeInterval = 20, description: String = "") -> XCTWaiter.Result {
        return wait(for: "exists == false", timeout: timeout, description: description)
    }
}
