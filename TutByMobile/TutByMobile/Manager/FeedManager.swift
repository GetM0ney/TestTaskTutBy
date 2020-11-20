//
//  FeedManager.swift
//  TutByMobile
//
//  Created by Владимир Лишаненко on 11/18/20.
//
import FeedKit
import Foundation

protocol FeedManagerDelegate {
    func updateImages()
}

class FeedManager: NSObject {
    static let shared = FeedManager()

    var delegate: FeedManagerDelegate?
    private var feedModelItems = [FeedModel]()
    private var parser = FeedParser(URL: Constants.rssURL)
    private var feed: RSSFeed?
    private var maxIndex = 9
    private var imageArray = [UIImage]()
    
    func configure(completion: @escaping (Bool)->()) {
        parser.parseAsync { result in
            switch result {
            case .success(let feed):
                self.feed = feed.rssFeed
                let items = self.feed?.items
                self.convert(items: items)
                self.setImageArray()
                DispatchQueue.main.async {
                    completion(true)
                }
                print("sosi")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func convert(items: [RSSFeedItem]?) {
        if let items = items {
            for i in stride(from: 0, to: items.count, by: +1) {
                feedModelItems.append(FeedModel(title: items[i].title, link: items[i].link, date: items[i].pubDate, description: items[i].description))
            }
        }
    }
    
    func setImageArray() {
        for i in 0...10 {
            if let data = try? Data(contentsOf: feedModelItems[i].imageURL!) {
                imageArray.append(UIImage(data: data)!)
            }
        }
    }
    
    func getImageArrayElement(at index: Int) -> UIImage {
        return imageArray[index]
    }
    
    func getInfo(at index: Int) -> FeedModel {
        if maxIndex - index < 9 {
            maxIndex += 1
            if let data = try? Data(contentsOf: feedModelItems[maxIndex].imageURL!) {
                imageArray.append(UIImage(data: data)!)
                delegate?.updateImages()
            }
        }
        return feedModelItems[index]
    }
    
    func getMaxIndex() -> Int {
        return maxIndex + 1
    }
    
    func getFeedModelItemsCount() -> Int {
        return feedModelItems.count
    }
}
