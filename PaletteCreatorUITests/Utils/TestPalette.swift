//
//  TestPalette.swift
//  PaletteCreatorUITests
//
//  Created by Dave Shu on 11/8/18.
//  Copyright © 2018 Dave Shu. All rights reserved.
//

import Foundation

enum TestPalette {
    typealias Palette = PaletteCreatorApp.Palette
    static let mojave = Palette(name: "Mojave 🏜", colors: [RGBTriplet(r: 119, g: 109, b: 90),
                                                              RGBTriplet(r: 152, g: 125, b: 124),
                                                              RGBTriplet(r: 160, g: 156, b: 176),
                                                              RGBTriplet(r: 163, g: 185, b: 201),
                                                              RGBTriplet(r: 171, g: 218, b: 225)])
    static let green = Palette(name: "Green 🐸", colors: [RGBTriplet(r: 190, g: 230, b: 206),
                                                            RGBTriplet(r: 188, g: 255, b: 219),
                                                            RGBTriplet(r: 141, g: 255, b: 205),
                                                            RGBTriplet(r: 104, g: 216, b: 155),
                                                            RGBTriplet(r: 79, g: 157, b: 105)])
    static let purple = Palette(name: "Purple 👾", colors: [RGBTriplet(r: 242, g: 215, b: 238),
                                                              RGBTriplet(r: 211, g: 188, b: 192),
                                                              RGBTriplet(r: 165, g: 102, b: 139),
                                                              RGBTriplet(r: 105, g: 48, b: 109),
                                                              RGBTriplet(r: 14, g: 16, b: 61)])
    static let orange = Palette(name: "Orange 🍊", colors: [RGBTriplet(r: 243, g: 183, b: 0),
                                                              RGBTriplet(r: 250, g: 163, b: 0),
                                                              RGBTriplet(r: 229, g: 124, b: 4),
                                                              RGBTriplet(r: 255, g: 98, b: 1),
                                                              RGBTriplet(r: 246, g: 62, b: 2)])
}
