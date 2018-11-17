//
//  ColorView.swift
//  PaletteCreator
//
//  Created by Dave Shu on 11/7/18.
//  Copyright © 2018 Dave Shu. All rights reserved.
//

import UIKit

@IBDesignable
class ColorView: UIView {
    @IBInspectable
    var paletteColor: UIColor = .gray {
        didSet {
            backgroundColor = paletteColor
        }
    }
    
    @IBInspectable
    var paletteIndex: Int = 0 {
        didSet {
            updateAccessibility()
        }
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        // isAccessibilityElement is false by default for regular UIViews
        isAccessibilityElement = true
        updateAccessibility()
    }

    // MARK: - Accessibility
    private func updateAccessibility() {
        accessibilityIdentifier = "color-view-\(paletteIndex)"
    }
}
