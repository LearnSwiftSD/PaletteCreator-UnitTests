//
//  UIView+PinToEdges.swift
//  PaletteCreator
//
//  Created by Dave Shu on 11/7/18.
//  Copyright © 2018 Dave Shu. All rights reserved.
//

import UIKit

extension UIView {
    func pinToEdges(of otherView: UIView, inset: UIEdgeInsets = .zero) {
        otherView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -inset.left).isActive = true
        otherView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: inset.right).isActive = true
        otherView.topAnchor.constraint(equalTo: self.topAnchor, constant: -inset.top).isActive = true
        otherView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: inset.bottom).isActive = true
    }
}
