//
//  UIImageExtension.swift
//  RecipeFinder
//
//  Created by Alec O'Connor on 11/16/17.
//  Copyright © 2017 Alec O'Connor. All rights reserved.
//

import UIKit

extension UIImage {
    
    // Stack Overflow answer:
    //    https://stackoverflow.com/a/33675160/4146322
    //    Create a UIImage from a color
    
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
}
