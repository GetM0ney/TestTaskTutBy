//
//  UIImage.swift
//  TutByMobile
//
//  Created by Владимир Лишаненко on 11/19/20.
//

import Foundation
import UIKit

extension UIImage {
    func imageWithColor(color: UIColor, rect: CGRect) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1, height: rect.height)
        UIGraphicsBeginImageContext(rect.size)
        guard let context = UIGraphicsGetCurrentContext() else { return UIImage()}
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
