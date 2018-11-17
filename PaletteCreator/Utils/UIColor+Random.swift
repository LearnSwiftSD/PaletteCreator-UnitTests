//
//  UIColor+Random.swift
//  PaletteCreator
//
//  Created by Dave Shu on 11/4/18.
//  Copyright © 2018 Dave Shu. All rights reserved.
//

import UIKit

extension UIColor {
    static func random() -> UIColor {
        let values = (0...2).map { _ in CGFloat.random(in: 0.0...1.0) }
        return UIColor(red: values[0], green: values[1], blue: values[2], alpha: 1)
    }
}
