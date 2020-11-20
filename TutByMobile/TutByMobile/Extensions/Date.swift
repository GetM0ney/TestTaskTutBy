//
//  Date.swift
//  TutByMobile
//
//  Created by Владимир Лишаненко on 11/20/20.
//

import Foundation

extension Date {
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return formatter.string(from: self)
    }
}
