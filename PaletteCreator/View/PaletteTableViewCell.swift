//
//  PaletteTableViewCell.swift
//  PaletteCreator
//
//  Created by Dave Shu on 11/4/18.
//  Copyright © 2018 Dave Shu. All rights reserved.
//

import UIKit

class PaletteTableViewCell: UITableViewCell {
    static let defaultReuseIdentifier = "paletteCellId"
    static let defaultRowHeight: CGFloat = 100
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var colorViews: [ColorView]!
    
    var palette: Palette? {
        didSet {
            refreshViews()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        palette = nil
    }
    
    private func refreshViews() {
        guard let palette = palette else {
            nameLabel.text = nil
            colorViews.forEach { $0.paletteColor = .clear }
            return
        }
        
        nameLabel.text = palette.name
        for (color, view) in zip(palette.colors, colorViews) {
            view.paletteColor = color
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        // UITableViewCell superclass will turn view background colors gray
        // when highlighting, so set background colors back to palette colors
        refreshViews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // UITableViewCell superclass will turn view background colors gray
        // when selected, so set background colors back to palette colors
        refreshViews()
    }
}

