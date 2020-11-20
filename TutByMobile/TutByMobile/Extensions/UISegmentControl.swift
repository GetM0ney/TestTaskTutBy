//
//  UISegmentControl.swift
//  TutByMobile
//
//  Created by Владимир Лишаненко on 11/18/20.
//
import UIKit

extension UISegmentedControl {
    func clearBG() {
        let clearImage = UIImage().imageWithColor(color: .clear, rect: self.bounds)
        setBackgroundImage(clearImage, for: .normal, barMetrics: .default)
        setBackgroundImage(clearImage, for: .selected, barMetrics: .default)
        setDividerImage(clearImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
}

