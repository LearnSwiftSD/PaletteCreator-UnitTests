//
//  PaletteCreatorApp.swift
//  PaletteCreatorUITests
//
//  Created by Dave Shu on 11/4/18.
//  Copyright © 2018 Dave Shu. All rights reserved.
//

import XCTest

class PaletteCreatorApp: XCUIApplication {
    let colorViewIndexRange = 0...4
    
    enum RGBIndex: Int, CaseIterable {
        case red = 0, green = 1, blue = 2
        
        // Used for making accessibilityIdentifier strings
        var name: String {
            switch self {
            case .red: return "red"
            case .green: return "green"
            case .blue: return "blue"
            }
        }
    }
    
    enum AppState: Equatable {
        case paletteTable, create, paletteDetail(paletteName: String), edit(paletteName: String)
    }
    
    struct Palette {
        static let colorCount = 5
        var name: String
        var colors: [RGBTriplet]
        
        init(name: String, colors: [RGBTriplet]) {
            precondition(colors.count == Palette.colorCount, "Palette must contain exactly \(Palette.colorCount) colors.")
            self.name = name
            self.colors = colors
        }
    }
}

// MARK: - Navigation
extension PaletteCreatorApp {
    func readAppState() -> AppState {
        if paletteTable.exists {
            return .paletteTable
        }
        else if createPaletteNavBar.exists {
            return .create
        }
        else if editPaletteNavBar.exists {
            return .edit(paletteName: editPaletteNavBar.readNavigationBarLabel()!)
        }
        else if paletteDetailView.exists {
            return .paletteDetail(paletteName: paletteDetailNavBar.readNavigationBarLabel()!)
        }
        else {
            fatalError("Unknown app state")
        }
    }
    
    // Note: Navigation defaults to cancel when creating a new or editing a palette
    func navigate(to newState: AppState) {
        let currentState = readAppState()
        guard currentState != newState else {
            return
        }
        
        switch (currentState, newState) {
        case (.create, .paletteTable):
            entryCancelButton.tap()
            XCTAssert(paletteTable.waitForExistence(timeout: 1), "Wait for create VC dismiss animation to complete")
        case (.paletteDetail, .paletteTable):
            paletteDetailBackButton.tap()
            XCTAssert(paletteTable.waitForExistence(timeout: 1), "Wait for detail VC pop animation to complete")
        case (.edit, .paletteTable):
            entryCancelButton.tap()
            XCTAssert(paletteDetailView.waitForExistence(timeout: 1), "Wait for edit VC dismiss animation to complete")
            navigate(to: .paletteTable)
        case (_, .create):
            navigate(to: .paletteTable)
            paletteTableAddButton.tap()
            XCTAssert(entryView.waitForExistence(timeout: 1), "Wait for create VC present animation to complete")
        case (_, .paletteDetail(let name)):
            navigate(to: .paletteTable)
            paletteTable.staticTexts[name].tap()
            XCTAssert(paletteDetailView.waitForExistence(timeout: 1), "Wait for detail VC present animation to complete")
        case (_, .edit(let name)):
            navigate(to: .paletteDetail(paletteName: name))
            paletteDetailEditButton.tap()
            XCTAssert(entryView.waitForExistence(timeout: 1), "Wait for edit VC present animation to complete")
        default:
            break
        }
    }
}

// MARK: - Color views
extension PaletteCreatorApp {
    func colorView(at index: Int, in containingView: XCUIElement) -> XCUIElement {
        return containingView.otherElements["color-view-\(index)"]
    }
    
    func colorOfColorView(at index: Int, in containingView: XCUIElement) -> UIColor {
        let image = colorView(at: index, in: containingView).screenshot().image
        return image.getPixelColor(at: CGPoint(x: image.size.width/2, y: image.size.height/2))!
    }

    func validateColorViews(in containingView: XCUIElement, colors: [RGBTriplet], episilon: UInt8 = 5) {
        for (index, expectedColor) in zip(colorViewIndexRange, colors) {
            let actualColor = colorOfColorView(at: index, in: containingView).rgbTriplet()
            
            let result = actualColor.roughlyEquals(expectedColor, episilon: episilon)
            XCTAssert(result, "Unexpected color in view #\(index). Expected=\(expectedColor), Actual=\(actualColor)")
        }
    }
}

// MARK: - Palette Table
extension PaletteCreatorApp {
    var paletteTable: XCUIElement {
        return tables["palette-table"]
    }
    
    var paletteTableAddButton: XCUIElement {
        return buttons["palette-table-add-button"]
    }
    
    var paletteTableEditOrDoneButton: XCUIElement {
        return buttons["palette-table-edit-button"]
    }
    
    var paletteTableDeleteAllButton: XCUIElement {
        return buttons["palette-table-delete-all-button"]
    }
    
    // UI testing quirk: it's non-trival to set accessibilityIdentifier on alerts
    // so we just use accessibilityLabel here
    var paletteTableDeleteAllAlert: XCUIElement {
        return alerts["Delete all palettes?"]
    }
    
    var paletteTableDeleteAllAlertDeleteButton: XCUIElement {
        return paletteTableDeleteAllAlert.buttons["Delete"]
    }
    
    var paletteTableCells: [XCUIElement] {
        return paletteTable.cells.allElementsBoundByIndex
    }

    func readPaletteCellName(_ cell: XCUIElement) -> String {
        return cell.staticTexts.firstMatch.label
    }

    func readAllPaletteCellNames() -> [String] {
        return paletteTableCells.map { readPaletteCellName($0) }
    }
    
    func findLastPaletteCell(named paletteName: String) -> XCUIElement {
        let palettes = readAllPaletteCellNames()
        // Palette names don't have to be unique, and new palettes are added at the bottom of the table
        guard let index = palettes.lastIndex(where: { $0 == paletteName }) else {
            fatalError("\(paletteName) not found in palette table")
        }
        return paletteTable.cells.element(boundBy: index)
    }
    
    func validatePaletteCell(_ cell: XCUIElement, expected: Palette) {
        let actualName = readPaletteCellName(cell)
        XCTAssertEqual(actualName, expected.name, "Expected=\(expected.name), actual=\(actualName)")
        validateColorViews(in: cell, colors: expected.colors)
    }
}

// MARK: - Entry (Add new/Edit)
extension PaletteCreatorApp {
    var createPaletteNavBar: XCUIElement {
        return navigationBars["create-palette-bar"]
    }
    
    var editPaletteNavBar: XCUIElement {
        return navigationBars["edit-palette-bar"]
    }
    
    var entryCancelButton: XCUIElement {
        return buttons["palette-entry-cancel-button"]
    }
    
    var entrySaveButton: XCUIElement {
        return buttons["palette-entry-save-button"]
    }

    var entryNameTextField: XCUIElement {
        return textFields["palette-entry-name-text-field"]
    }
    
    var entryView: XCUIElement {
        return otherElements["palette-entry-view"]
    }
    
    func colorOfColorSelectButton(at index: Int) -> UIColor {
        let image = colorSelectButton(at: index).screenshot().image
        return image.getPixelColor(at: CGPoint(x: 1, y: 1))!
    }
    
    func colorSelectButton(at index: Int) -> XCUIElement {
        precondition(colorViewIndexRange.contains(index))
        return buttons["color-button-\(index)"]
    }
    
    func setColorSliders(to triplet: RGBTriplet) {
        colorSlider(for: .red).adjust(toNormalizedSliderPosition: triplet.redNormalized)
        colorSlider(for: .green).adjust(toNormalizedSliderPosition: triplet.greenNormalized)
        colorSlider(for: .blue).adjust(toNormalizedSliderPosition: triplet.blueNormalized)
    }
    
    func readRGBValueFromColorSliders() -> RGBTriplet {
        let red = colorSlider(for: .red).normalizedSliderPosition
        let green = colorSlider(for: .green).normalizedSliderPosition
        let blue = colorSlider(for: .blue).normalizedSliderPosition
        return RGBTriplet.normalized(r: red, g: green, b: blue)
    }
    
    func colorSlider(for component: RGBIndex) -> XCUIElement {
        return sliders["\(component.name)-slider"]
    }
    
    func colorLabel(for component: RGBIndex) -> XCUIElement {
        return staticTexts["\(component.name)-label"]
    }
    
    func readValueFromColorLabel(_ component: RGBIndex) -> UInt8 {
        let text = colorLabel(for: component).label
        return UInt8(text.components(separatedBy: " ").last!)!
    }
    
    func readRGBValueFromLabels() -> RGBTriplet {
        let red = readValueFromColorLabel(.red)
        let green = readValueFromColorLabel(.green)
        let blue = readValueFromColorLabel(.blue)
        return RGBTriplet(r: red, g: green, b: blue)
    }
    
    // Validates the controls in the palette entry view
    func validatePaletteEntry(colors: [RGBTriplet], episilon: UInt8 = 5) -> [RGBTriplet] {
        var labelValues: [RGBTriplet] = []
        
        for (index, expectedRGB) in zip(colorViewIndexRange, colors) {
            colorSelectButton(at: index).tap()
            
            let buttonRGB = colorOfColorSelectButton(at: index).rgbTriplet()
            let buttonResult = buttonRGB.roughlyEquals(expectedRGB, episilon: episilon)
            XCTAssert(buttonResult, "Unexpected color for button at color #\(index). Expected=\(expectedRGB), Actual=\(buttonRGB)")

            // Validate labels
            let labelsRGB = readRGBValueFromLabels()
            labelValues.append(labelsRGB)
            let labelsResult = labelsRGB.roughlyEquals(expectedRGB, episilon: episilon)
            XCTAssert(labelsResult, "Unexpected color for label at color #\(index). Expected=\(expectedRGB), Actual=\(labelsRGB)")
            
            // Validate sliders
            let slidersRGB = readRGBValueFromColorSliders()
            let slidersResult = slidersRGB.roughlyEquals(expectedRGB, episilon: episilon)
            XCTAssert(slidersResult, "Unexpected color for slider at color #\(index). Expected=\(expectedRGB), Actual=\(slidersRGB)")
        }
        return labelValues
    }
}

// MARK: - Palette Detail
extension PaletteCreatorApp {
    var paletteDetailView: XCUIElement {
        return otherElements["palette-detail-view"]
    }
    
    var paletteDetailNavBar: XCUIElement {
        return navigationBars["palette-detail-bar"]
    }
    
    var paletteDetailBackButton: XCUIElement {
        return paletteDetailNavBar.buttons["Palettes"]
    }
    
    var paletteDetailEditButton: XCUIElement {
        return buttons["palette-detail-edit-button"]
    }
    
    func validatePaletteDetail(_ palette: Palette) {
        XCTAssertEqual(paletteDetailNavBar.readNavigationBarLabel(), palette.name)
        validateColorViews(in: paletteDetailView, colors: palette.colors)
    }
}

// MARK: - Convenience
extension PaletteCreatorApp {
    func createPalette(_ palette: Palette) -> Palette {
        var actualColors: [RGBTriplet] = []
        
        XCTContext.runActivity(named: "Navigate to create palette") { _ in
            navigate(to: .create)
        }
        
        XCTContext.runActivity(named: "Set name") { _ in
            entryNameTextField.tap()
            entryNameTextField.clearTextAndType(palette.name)
            entryNameTextField.typeText("\n")
        }
        
        XCTContext.runActivity(named: "Set colors") { _ in
            for (index, color) in zip(colorViewIndexRange, palette.colors) {
                colorSelectButton(at: index).tap()
                setColorSliders(to: color)
            }
        }
        
        XCTContext.runActivity(named: "Validate palette") { _ in
            // Accept a greater margin of error in this case
            actualColors = validatePaletteEntry(colors: palette.colors, episilon: 10)
        }
        
        XCTContext.runActivity(named: "Save palette") { _ in
            savePalette()
        }

        return Palette(name: palette.name, colors: actualColors)
    }
    
    func createPalettes(_ palettes: [Palette]) -> [Palette] {
        var actualPalettes: [Palette] = []
        XCTContext.runActivity(named: "Create \(palettes.count) palettes") { _ in
            for palette in palettes {
                let actualPalette = createPalette(palette)
                actualPalettes.append(actualPalette)
            }
        }
        return actualPalettes
    }
    
    func savePalette() {
        entrySaveButton.tap()
        createPaletteNavBar.ensureExistsFalse(timeout: 3, description: "Wait for add new modal to finish dismissing")
    }
    
    func deleteAllPalettes() {
        navigate(to: .paletteTable)
        
        guard paletteTableCells.count > 0 else {
            return
        }
        
        if !paletteTableDeleteAllButton.exists {
            paletteTableEditOrDoneButton.tap()
        }
        
        paletteTableDeleteAllButton.tap()
        paletteTableDeleteAllAlertDeleteButton.tap()
        sleep(2)
        
        paletteTableEditOrDoneButton.tap()
    }    
}
