//
//  XCUIElement+UIHelpers.swift
//  PaletteCreatorUITests
//
//  Created by Dave Shu on 11/4/18.
//  Copyright © 2018 Dave Shu. All rights reserved.
//

import XCTest

// MARK: - UINavigationBar
extension XCUIElement {
    func readNavigationBarLabel() -> String? {
        return otherElements.allElementsBoundByIndex.first?.label
    }
}

// MARK: - UITextField
extension XCUIElement {
    func clearTextAndType(_ text: String) {
        let stringValue = value as! String
        let deletionString = String(repeating: "\u{8}", count: stringValue.count)
        typeText(deletionString)
        typeText(text)
    }
}

// MARK: - UITableViewCell
extension XCUIElement {
    func swipeToDeleteCell() {
        let start = coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.5))
        let end = coordinate(withNormalizedOffset: CGVector(dx: 0.1, dy: 0.5))
        start.press(forDuration: 0.1, thenDragTo: end)
    }
}
