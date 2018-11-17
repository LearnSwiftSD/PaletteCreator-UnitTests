//
//  PaletteCreatorTests.swift
//  PaletteCreatorTests
//
//  Created by Dave Shu on 11/3/18.
//  Copyright © 2018 Dave Shu. All rights reserved.
//

import XCTest
@testable import PaletteCreator

class PaletteCreatorTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBasicPaletteCodableRoundtrip() throws {
        let randomPalette = Palette.random(named: "Random test palette")
        let jsonEncoder = JSONEncoder()
        let encodedPalette = try jsonEncoder.encode(randomPalette)
        let jsonDecoder = JSONDecoder()
        let decodedPalette = try jsonDecoder.decode(Palette.self, from: encodedPalette)
        XCTAssert(randomPalette == decodedPalette, "Palette codable round trip failed")
    }
    
    func testLegacyPaletteDecode() throws {
        let legacyPalette = Palette(name: "A test palette", colors: [.orange, .magenta, .cyan, .brown, .purple])
        let legacyJSON = "{\"name\":\"A test palette\",\"colors\":[{\"red\":255,\"green\":127,\"blue\":0},{\"red\":255,\"green\":0,\"blue\":255},{\"red\":0,\"green\":255,\"blue\":255},{\"red\":153,\"green\":102,\"blue\":51},{\"red\":127,\"green\":0,\"blue\":127}]}"
        guard let legacyData = legacyJSON.data(using: .utf8) else {
            XCTFail("Could not initialize legacy data using string")
            return
        }
        let jsonDecoder = JSONDecoder()
        let decodedPalette = try jsonDecoder.decode(Palette.self, from: legacyData)
        XCTAssert(legacyPalette == decodedPalette, "Legacy Palette decoding failed!")
    }
}
