//
//  FeedManager.swift
//  TutByMobile
//
//  Created by Владимир Лишаненко on 11/18/20.
//
import FeedKit
import Foundation

enum WatchMode {
    case recent
    case new
}

protocol FeedManagerDelegate {
    func updateImages()
}

class FeedManager: NSObject {
    static let shared = FeedManager()
    
    var delegate: FeedManagerDelegate?
    private var mode: WatchMode = .new
    private var manager = CoreDataManager()
    private var feedModelItemsWithInternet = [FeedModel]()
    private var feedModelItemsRecent = [FeedModel]()
    private var parser = FeedParser(URL: AppConstants.rssURL)
    private var feed: RSSFeed?
    private var maxIndex = 9
    private var recentNewsMaxIndex = 0
    private var imageArrayWithInternet = [UIImage]()
    private var imageArrayWithoutInternet = [UIImage]()
    
    lazy var imageCache: NSCache<NSString, NSData> = {
        NSCache<NSString, NSData>()
    }()
    
    func configure(completion: @escaping (Bool)->()) {
        switch mode {
        case .new:
            if feedModelItemsWithInternet.isEmpty {
                parser.parseAsync { result in
                    switch result {
                    case .success(let feed):
                        self.feed = feed.rssFeed
                        
                        let items = self.feed?.items
                        self.convert(items: items)
                        
                        let itemsFetched = self.manager.fetchRecordsForEntity("News")
                        itemsFetched.forEach { (item) in
                            self.manager.deleteRecordForEntity(item)
                        }
                        
                        self.setImageArray()
                        DispatchQueue.main.async {
                            completion(true)
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            } else {
                
            }
            
        case .recent:
            let items = manager.fetchRecordsForEntity("News") as? [News]
            if let items = items {
                if !items.isEmpty {
                    recentNewsMaxIndex = items.count
                    for i in stride(from: 0, to: items.count, by: +1) {
                        feedModelItemsRecent.append(FeedModel(title: items[i].title,
                                                              link: items[i].link,
                                                              date: items[i].date?.toDate(),
                                                              fullDescription: items[i].textDescription))
                        imageArrayWithoutInternet.append(UIImage(data: imageCache.object(forKey: feedModelItemsWithInternet[i].imageURL!.absoluteString as NSString)! as Data)!)
                    }
                } else {
                    print("No saved Items")
                }
            }
        }
    }
    
    func convert(items: [RSSFeedItem]?) {
        if let items = items {
            for i in stride(from: 0, to: items.count, by: +1) {
                feedModelItemsWithInternet.append(FeedModel(title: items[i].title, link: items[i].link, date: items[i].pubDate, fullDescription: items[i].description))
            }
        }
    }
    
    func cachingImage(url: String, data: Data) {
        self.imageCache.setObject(NSData(data: data), forKey: url as NSString)
    }
    
    func getCachedImage(url: String) -> UIImage? {
        if let cachedImageData = imageCache.object(forKey: url as NSString) as Data? {
            return UIImage(data: cachedImageData)
        }
        return nil
    }
    
    func setImageArray() {
        for i in 0...10 {
            if let data = try? Data(contentsOf: feedModelItemsWithInternet[i].imageURL!) {
                imageArrayWithInternet.append(UIImage(data: data)!)
            }
        }
    }
    
    func getImageArrayElement(at index: Int) -> UIImage {
        switch mode {
        case .new:
            return imageArrayWithInternet[index]
        case .recent:
            return imageArrayWithoutInternet[index]
        }
    }
    
    func getInfo(at index: Int) -> FeedModel {
        switch mode {
        case .new:
            if maxIndex - index < 9 {
                maxIndex += 1
                print(feedModelItemsWithInternet[maxIndex].imageURL!)
                if let data = try? Data(contentsOf: feedModelItemsWithInternet[maxIndex].imageURL!) {
                    imageArrayWithInternet.append(UIImage(data: data)!)
                    delegate?.updateImages()
                }
            }
            
            if let news = manager.createRecordForEntity("News") as? News {
                news.link = feedModelItemsWithInternet[index].link
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
                news.date = formatter.string(from: feedModelItemsWithInternet[index].date!)
                news.imageURL = feedModelItemsWithInternet[index].imageURL?.absoluteString
                news.title = feedModelItemsWithInternet[index].title
                news.textDescription = feedModelItemsWithInternet[index].fullDescription
                manager.saveContext()
            }
            if imageCache.object(forKey: feedModelItemsWithInternet[index].imageURL!.absoluteString as NSString) == nil {
                if let data = try? Data(contentsOf: feedModelItemsWithInternet[index].imageURL!) {
                    cachingImage(url: feedModelItemsWithInternet[index].imageURL!.absoluteString, data: data)
                }
            }
            return feedModelItemsWithInternet[index]
        case .recent:
            return feedModelItemsRecent[index]
        }
    }
    
    func getMaxIndex() -> Int {
        return maxIndex + 1
    }
    
    func setMax(index: Int) {
        maxIndex = index
    }
    
    func setMaxForRecent() -> Int {
        return recentNewsMaxIndex
    }
    
    func getFeedModelItemsCount() -> Int {
        return feedModelItemsWithInternet.count
    }
    
    func setMode(mode: WatchMode) {
        self.mode = mode
    }
    
    func getMode() -> WatchMode {
        return self.mode
    }
}
