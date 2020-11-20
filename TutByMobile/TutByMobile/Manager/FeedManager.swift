//
//  FeedManager.swift
//  TutByMobile
//
//  Created by Владимир Лишаненко on 11/18/20.
//
import FeedKit
import Foundation

class FeedManager: NSObject {
    static let shared = FeedManager()

    private var feedModelItems = [FeedModel]()
    private var parser = FeedParser(URL: Constants.rssURL)
    private var feed: RSSFeed?
    
    private var imageArray = [UIImage]()
    
    func configure() {
        parser.parseAsync { result in
            switch result {
            case .success(let feed):
                self.feed = feed.rssFeed
                let items = self.feed?.items
                self.convert(items: items)
                print("sosi")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        setImageArray()
    }
    
    func convert(items: [RSSFeedItem]?) {
        if let items = items {
            for i in stride(from: 0, to: items.count, by: +1) {
                feedModelItems.append(FeedModel(title: items[i].title, link: items[i].link, date: items[i].pubDate, description: items[i].description))
            }
        }
    }
    
    func setImageArray() {
        for _ in 0...10 {
            imageArray.append(UIImage(named: "screen")!)
        }
    }
    
    func getImageArrayElement(at index: Int) -> UIImage {
        return imageArray[index]
    }
//    func getImage(for item: FeedModel) -> UIImage {
//        return
//    }
        
}
