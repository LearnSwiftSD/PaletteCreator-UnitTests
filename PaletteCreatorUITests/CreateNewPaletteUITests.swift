//
//  CreateNewPaletteUITests.swift
//  PaletteCreatorUITests
//
//  Created by Dave Shu on 11/10/18.
//  Copyright © 2018 Dave Shu. All rights reserved.
//

import XCTest

class CreateNewPaletteUITests: XCTestCase {
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

    func testAddNewPalette() {
        let palette = TestPalette.mojave
        var actualColors: [RGBTriplet] = []
        
        // Add a new palette
        XCTContext.runActivity(named: "Add new palette") { _ in
            let actualPalette = app.createPalette(palette)
            actualColors = actualPalette.colors
        }
        
        XCTContext.runActivity(named: "Verify the palette cell") { _ in
            let cell = app.findLastPaletteCell(named: palette.name)
            app.validateColorViews(in: cell, colors: actualColors)
        }
        
        XCTContext.runActivity(named: "Verify the palette in detail") { _ in
            app.navigate(to: .paletteDetail(paletteName: palette.name))
            app.validateColorViews(in: app.paletteDetailView, colors: actualColors)
        }
        
        XCTContext.runActivity(named: "Verify the palette in Edit") { _ in
            app.navigate(to: .edit(paletteName: palette.name))
            _ = app.validatePaletteEntry(colors: actualColors)
        }
    }
}
