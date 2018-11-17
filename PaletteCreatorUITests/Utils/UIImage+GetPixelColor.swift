//
//  UIImage+GetColor.swift
//  PaletteCreator
//
//  Created by Dave Shu on 11/4/18.
//  Copyright © 2018 Dave Shu. All rights reserved.
//

import UIKit

extension UIImage {
    func getPixelColor(at point: CGPoint) -> UIColor? {
        guard let cgImage = cgImage,
            let pixelData = cgImage.dataProvider?.data,
            let data = CFDataGetBytePtr(pixelData) else {
            return nil
        }

        let pixelInfo = ((Int(size.width) * Int(point.y)) + Int(point.x)) * 4
        
        let r = CGFloat(data[pixelInfo])/255.0
        let g = CGFloat(data[pixelInfo+1])/255.0
        let b = CGFloat(data[pixelInfo+2])/255.0
        let a = CGFloat(data[pixelInfo+3])/255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}
