//
//  RGBTriplet+RoughlyEquals.swift
//  PaletteCreatorUITests
//
//  Created by Dave Shu on 11/5/18.
//  Copyright © 2018 Dave Shu. All rights reserved.
//

import Foundation

extension RGBTriplet {
    func roughlyEquals(_ other: RGBTriplet, episilon: UInt8 = 5) -> Bool {
        return (abs(Int(self.red) - Int(other.red)) <= episilon) &&
            (abs(Int(self.green) - Int(other.green)) <= episilon) &&
            (abs(Int(self.blue) - Int(other.blue)) <= episilon)
    }
}
