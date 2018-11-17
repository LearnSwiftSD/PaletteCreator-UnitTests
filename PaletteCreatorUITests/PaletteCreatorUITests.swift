//
//  PaletteCreatorUITests.swift
//  PaletteCreatorUITests
//
//  Created by Dave Shu on 11/3/18.
//  Copyright © 2018 Dave Shu. All rights reserved.
//

import XCTest

class PaletteCreatorUITests: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFoo() {
        let app = XCUIApplication()
        
    }
    
    func testExample() {
        
        let app = XCUIApplication()
        let palettesNavigationBar = app.navigationBars["Palettes"]
        palettesNavigationBar/*@START_MENU_TOKEN@*/.buttons["palette-table-add-button"]/*[[".buttons[\"Add\"]",".buttons[\"palette-table-add-button\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.buttons["color-button-1"]/*[[".otherElements[\"palette-entry-view\"].buttons[\"color-button-1\"]",".buttons[\"color-button-1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.buttons["color-button-3"]/*[[".otherElements[\"palette-entry-view\"].buttons[\"color-button-3\"]",".buttons[\"color-button-3\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.textFields["palette-entry-name-text-field"]/*[[".otherElements[\"palette-entry-view\"].textFields[\"palette-entry-name-text-field\"]",".textFields[\"palette-entry-name-text-field\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["create-palette-bar"]/*@START_MENU_TOKEN@*/.buttons["palette-entry-save-button"]/*[[".buttons[\"Save\"]",".buttons[\"palette-entry-save-button\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        palettesNavigationBar/*@START_MENU_TOKEN@*/.buttons["palette-table-edit-button"]/*[[".buttons[\"Edit\"]",".buttons[\"palette-table-edit-button\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        palettesNavigationBar/*@START_MENU_TOKEN@*/.buttons["palette-table-edit-button"]/*[[".buttons[\"Done\"]",".buttons[\"palette-table-edit-button\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        app.buttons["color-button-1"].tap()
        
        app.sliders["red-slider"].adjust(toNormalizedSliderPosition: 0.5)
        
        app.otherElements["color-view-1"].exists
        
        app.navigationBars["edit-palette-bar"].waitForExistence(timeout: 1)
    }
}
