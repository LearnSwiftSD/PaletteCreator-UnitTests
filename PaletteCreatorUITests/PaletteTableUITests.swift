//
//  PaletteTableUITests.swift
//  PaletteCreatorUITests
//
//  Created by Dave Shu on 11/10/18.
//  Copyright © 2018 Dave Shu. All rights reserved.
//

import XCTest

class PaletteTableUITests: XCTestCase {
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

    func testDisplayAllPalettes() {
        let palettes = [TestPalette.green, TestPalette.purple, TestPalette.orange, TestPalette.mojave]
        var actualPalettes: [Palette] = []
        
        XCTContext.runActivity(named: "Create \(palettes.count) palettes") { _ in
            actualPalettes = app.createPalettes(palettes)
        }
        
        XCTContext.runActivity(named: "Verify palettes in table") { _ in
            app.navigate(to: .paletteTable)
            for (cell, palette) in zip(app.paletteTableCells, actualPalettes) {
                app.validatePaletteCell(cell, expected: palette)
            }
        }
    }
    
    func testDeleteSinglePalette() {
        let palettes = [TestPalette.purple, TestPalette.green, TestPalette.orange]
        var paletteNames: [String] = []
        let indexToDelete = 1
        
        XCTContext.runActivity(named: "Create \(palettes.count) palettes and get names") { _ in
            _ = app.createPalettes(palettes)
            
            paletteNames = app.readAllPaletteCellNames()
            paletteNames.remove(at: indexToDelete)
        }
        
        XCTContext.runActivity(named: "Delete cell #\(indexToDelete) and verify") { _ in
            app.paletteTableCells[indexToDelete].swipeToDeleteCell()
            XCTAssertEqual(paletteNames, app.readAllPaletteCellNames())
        }
    }
    
    func testDeleteAllPalettes() {
        let palettes = [TestPalette.purple, TestPalette.green, TestPalette.orange]

        XCTContext.runActivity(named: "Create \(palettes.count) palettes") { _ in
            _ = app.createPalettes(palettes)
        }

        XCTContext.runActivity(named: "Delete all palettes and verify") { _ in
            app.deleteAllPalettes()
            
            XCTAssert(app.paletteTableCells.isEmpty)
        }
    }
    
    func testViewPaletteInDetail() {
        let palette = TestPalette.mojave
        var actualPalette: Palette!
        
        XCTContext.runActivity(named: "Create palette") { _ in
            actualPalette = app.createPalette(palette)
        }
        
        XCTContext.runActivity(named: "View palette in detail and verify") { _ in
            app.navigate(to: .paletteDetail(paletteName: palette.name))
            app.validatePaletteDetail(actualPalette)
        }
    }
    
    func testThatPalettesSaveAndLoadFromDisk() {
        let palettes = [TestPalette.mojave, TestPalette.green, TestPalette.purple, TestPalette.orange]
        let actualPalettes: [Palette] = app.createPalettes(palettes)
        
        XCTContext.runActivity(named: "Verify palettes in table") { _ in
            app.navigate(to: .paletteTable)
            for (cell, palette) in zip(app.paletteTableCells, actualPalettes) {
                app.validatePaletteCell(cell, expected: palette)
            }
        }
        
        XCTContext.runActivity(named: "Kill the app and relaunch") { _ in
            app.terminate()
            app.launch()
        }
        
        XCTContext.runActivity(named: "Verify palettes in table") { _ in
            app.navigate(to: .paletteTable)
            for (cell, palette) in zip(app.paletteTableCells, actualPalettes) {
                app.validatePaletteCell(cell, expected: palette)
            }
        }
    }
    
    func testNavigateToCreateNewPalette() {
        XCTContext.runActivity(named: "Navigate to palette table") { _ in
            app.navigate(to: .paletteTable)
        }
        
        XCTContext.runActivity(named: "Navigate to create new palette") { _ in
            app.navigate(to: .create)
        }
        
        XCTContext.runActivity(named: "Navigate back to palette table") { _ in
            app.navigate(to: .paletteTable)
        }
    }
}
