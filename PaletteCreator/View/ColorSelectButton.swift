//
//  ColorButton.swift
//  PaletteCreator
//
//  Created by Dave Shu on 11/4/18.
//  Copyright © 2018 Dave Shu. All rights reserved.
//

import UIKit

// A color view that can be selected
@IBDesignable
class ColorSelectButton: UIButton {
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

    // Subviews
    let selectionView = UIView()
    // Selection view will show as border slightly larger than the color button
    private let selectionViewInset = UIEdgeInsets(top: -4, left: -4, bottom: -4, right: -4)
    private let selectionViewBorderWidth: CGFloat = 2
    
    // Button state
    override var isSelected: Bool {
        didSet {
            showIsSelected(isSelected)
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
        // Add selection view
        selectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(selectionView)
        selectionView.pinToEdges(of: self, inset: selectionViewInset)
        selectionView.layer.borderWidth = selectionViewBorderWidth
        
        updateAccessibility()
    }
    
    // MARK: - Private
    private func showIsSelected(_ isSelected: Bool) {
        if isSelected {
            selectionView.layer.borderColor = tintColor.cgColor
            selectionView.isHidden = false
        }
        else {
            selectionView.isHidden = true
        }
    }
    
    private func updateAccessibility() {
        accessibilityIdentifier = "color-button-\(paletteIndex)"
    }
}
