//
//  Palette.swift
//  PaletteCreator
//
//  Created by Dave Shu on 11/4/18.
//  Copyright © 2018 Dave Shu. All rights reserved.
//

import UIKit

struct Palette: Equatable, Codable, CustomStringConvertible {
    static let colorCount = 5
    var name: String
    var isRandom: Bool
    var colors: [UIColor] {
        willSet {
            assert(newValue.count == Palette.colorCount, "Palette must contain exactly \(Palette.colorCount) colors.")
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case name, colors, isRandom
    }

    // MARK: Init
    init(name: String, colors: [UIColor], isRandom: Bool = false) {
        precondition(colors.count == Palette.colorCount, "Palette must contain exactly \(Palette.colorCount) colors.")
        self.name = name
        self.colors = colors
        self.isRandom = isRandom
    }
    
    // MARK: Codable
    init(from decoder: Decoder) throws {
        #warning("Decode needs code to handle data encoded with old version without the isRandom field or there needs to be migration code to convert data from the old version to the current version")
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        let colorWrapper = try container.decode([RGBTriplet].self, forKey: .colors)
        colors = colorWrapper.map { UIColor(rgbTriplet: $0) }
        isRandom = try container.decode(Bool.self, forKey: .isRandom)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        
        let colorWrapper = colors.map { $0.rgbTriplet() }
        try container.encode(colorWrapper, forKey: .colors)
        
        try container.encode(isRandom, forKey: .isRandom)
    }
    
    // MARK: CustomStringConvertible
    var description: String {
        return "<Palette '\(name)': \(colors.map { $0.rgbTriplet() })>"
    }
    
    public static func == (lhs: Palette, rhs: Palette) -> Bool {
        return lhs.name == rhs.name && lhs.colors.map{$0.rgbTriplet()} == rhs.colors.map{$0.rgbTriplet()}
    }
}

// MARK: - Random
extension Palette {
    static func random(named name: String) -> Palette {
        return Palette(name: name, colors: (0..<Palette.colorCount).map { _ in UIColor.random() }, isRandom: true)
    }
}
