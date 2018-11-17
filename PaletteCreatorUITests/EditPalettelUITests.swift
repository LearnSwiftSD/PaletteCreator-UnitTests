//
//  EditPaletteUITests.swift
//  PaletteCreatorUITests
//
//  Created by Dave Shu on 11/10/18.
//  Copyright © 2018 Dave Shu. All rights reserved.
//

import XCTest

class EditPaletteUITests: XCTestCase {
    typealias Palette = PaletteCreatorApp.Palette
    let app = PaletteCreatorApp()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        XCTContext.runActivity(named: "Set app to a known state") { _ in
            app.deleteAllPalettes()
        }
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testThatEditChangesDetailAndTable() {
        let original = TestPalette.green
        var actual: Palette!
        var edited: Palette!
        let indexOfColorToEdit = 2
        let editedColor = RGBTriplet(r: 191, g: 53, b: 32)
        
        // Add a new palette
        XCTContext.runActivity(named: "Add new palette") { _ in
            actual = app.createPalette(original)
        }
        
        XCTContext.runActivity(named: "Validate palette cell colors") { _ in
            app.navigate(to: .paletteTable)
            let cell = app.findLastPaletteCell(named: actual.name)
            app.validatePaletteCell(cell, expected: actual)
        }
        
        XCTContext.runActivity(named: "Validate palette detail colors") { _ in
            app.navigate(to: .paletteDetail(paletteName: actual.name))
            app.validatePaletteDetail(actual)
        }
        
        XCTContext.runActivity(named: "Edit Color #\(indexOfColorToEdit) and save") { _ in
            // Change to a red color
            edited = actual
            edited.colors[indexOfColorToEdit] = editedColor

            app.navigate(to: .edit(paletteName: edited.name))
            app.colorSelectButton(at: indexOfColorToEdit).tap()
            app.setColorSliders(to: edited.colors[indexOfColorToEdit])
            edited.colors[indexOfColorToEdit] = app.readRGBValueFromLabels()
            app.savePalette()
        }
        XCTContext.runActivity(named: "Validate palette detail color changed correctly") { _ in
            app.navigate(to: .paletteDetail(paletteName: edited.name))
            app.validatePaletteDetail(edited)
        }
        
        XCTContext.runActivity(named: "Validate palette cell changed correctly") { _ in
            app.navigate(to: .paletteTable)
            let cell = app.findLastPaletteCell(named: edited.name)
            app.validatePaletteCell(cell, expected: edited)
        }
    }
}
