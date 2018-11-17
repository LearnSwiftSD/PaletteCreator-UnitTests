//
//  RGBTriplet.swift
//  PaletteCreator
//
//  Created by Dave Shu on 11/4/18.
//  Copyright © 2018 Dave Shu. All rights reserved.
//

import UIKit

struct RGBTriplet: Equatable, Codable, CustomStringConvertible {
    let red: UInt8
    let green: UInt8
    let blue: UInt8
    
    var array: [UInt8] {
        return [red, green, blue]
    }
    
    init(r: UInt8, g: UInt8, b: UInt8) {
        self.red = r
        self.green = g
        self.blue = b
    }
    
    // MARK: CustomStringConvertible
    var description: String {
        return "(\(red), \(green), \(blue))"
    }
}

// MARK: - Normalized representation
extension RGBTriplet {
    static func normalized(r: CGFloat, g: CGFloat, b: CGFloat) -> RGBTriplet {
        return RGBTriplet(r: UInt8(r * 255), g: UInt8(g * 255), b: UInt8(b * 255))
    }

    var redNormalized: CGFloat {
        return CGFloat(red)/255.0
    }
    
    var greenNormalized: CGFloat {
        return CGFloat(green)/255.0
    }
    
    var blueNormalized: CGFloat {
        return CGFloat(blue)/255.0
    }
}

// MARK: - Working with UIColor
extension UIColor {
    func rgbTriplet() -> RGBTriplet {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: nil)
        
        return RGBTriplet.normalized(r: red, g: green, b: blue)
    }
    
    convenience init(rgbTriplet: RGBTriplet) {
        self.init(red: rgbTriplet.redNormalized,
                  green: rgbTriplet.greenNormalized,
                  blue: rgbTriplet.blueNormalized,
                  alpha: 1)
    }
}
