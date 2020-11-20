//
//  PostModel.swift
//  TutByMobile
//
//  Created by Владимир Лишаненко on 11/17/20.
//
import Foundation
import FeedKit

struct FeedModel {
    var title: String?
    var link: String?
    var date: Date?
    var fullDescription: String?
    var textDescription: String? {
        let pattern = #"\>([\w\W]*)\<"#
        let regex = try! NSRegularExpression(pattern: pattern, options: .anchorsMatchLines)
        guard let string = fullDescription else { return nil }
        let stringRange = NSRange(location: 0, length: string.utf16.count)
        let matches = regex.matches(in: string, range: stringRange)
        guard let match = matches.first else { return nil }
   
        return (string as NSString).substring(with: match.range(at: 1))
    }
    var imageURL: URL? {
        let pattern = #"\"(.*(jpg|jpeg|png))"#
        let regex = try! NSRegularExpression(pattern: pattern, options: .anchorsMatchLines)
        guard let string = fullDescription else { return nil }
        let stringRange = NSRange(location: 0, length: string.utf16.count)
        let matches = regex.matches(in: string, range: stringRange)
        guard let match = matches.first else { return nil }
        
        return URL(string: (string as NSString).substring(with: match.range(at: 1)))
    }
}
    
