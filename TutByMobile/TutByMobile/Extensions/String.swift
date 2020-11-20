//
//  String.swift
//  TutByMobile
//
//  Created by Владимир Лишаненко on 11/20/20.
//

import Foundation

extension String {
    func toDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return dateFormatter.date(from: self)!
    }
}
