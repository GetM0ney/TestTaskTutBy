//
//  FeedView.swift
//  TutByMobile
//
//  Created by Владимир Лишаненко on 11/18/20.
//

import UIKit

protocol FeedViewDelegate {
    func pageDidChange()
}

class FeedView: UIView {
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        
        return scrollView
    }()
    private var itemAtIndex: ((_ bannerView: FeedView, _ index: Int) -> (UIView))!
    private var numberOfItems: Int = 0 {
        didSet {
            if oldValue != numberOfItems {
                delegate?.pageDidChange()
            }
            
        }
    }
    
    private(set) var currentPage: Int = 0 {
        didSet {
            if oldValue != currentPage {
                delegate?.pageDidChange()
            }
        }
    }
    
    private var items: [UIView] = [UIView]()
    
    var delegate: FeedViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        scrollView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        scrollView.delegate = self
        addSubview(scrollView)
        
        NSLayoutConstraint.activate([
                                        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
                                        scrollView.topAnchor.constraint(equalTo: topAnchor),
                                        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
                                        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor)])
    }
    
    func reloadData(numberOfItems: Int, itemAtIndex: @escaping ((_ bannerView: FeedView, _ index: Int)  -> (UIView))) {
        items.removeAll()
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        self.itemAtIndex = itemAtIndex
        self.numberOfItems = numberOfItems
        reloadScrollView()
    }
    
    func getCurrentItem() -> UIView {
        return items[currentPage]
    }
    
    func scrollToNewPage() {
        let offsetPoint = CGPoint(x: CGFloat(numberOfItems - 1) * frame.width, y: 0)
        scrollView.setContentOffset(offsetPoint, animated: true)
    }
    
    func scrollTo(page: Int) {
        let offsetPoint = CGPoint(x: CGFloat(page) * frame.width, y: 0)
        scrollView.setContentOffset(offsetPoint, animated: true)
    }
    
    private func reloadScrollView() {
        guard numberOfItems > 0 else { return }
        if numberOfItems == 1 {
            let firstItem: UIView = itemAtIndex(self, 0)
            addViewToIndex(view: firstItem, index: 0)
            scrollView.isScrollEnabled = false
            return
        }
        
        scrollView.isScrollEnabled = true
        for index in 0 ..< numberOfItems {
            let item: UIView = itemAtIndex(self, index)
            addViewToIndex(view: item, index: index)
        }
        
        scrollView.contentSize = CGSize(width: CGFloat(numberOfItems) * frame.size.width,
                                        height: frame.size.height)
    }
    
    private func addViewToIndex(view: UIView, index: Int) {
        items.append(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        let xPoint = CGFloat(index) * frame.size.width
        
        NSLayoutConstraint.activate([
                                        view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: xPoint + 10),
                                        view.topAnchor.constraint(equalTo: topAnchor),
                                        view.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
                                        view.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20)])
    }
}

extension FeedView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        if Int(offset) % Int(scrollView.frame.width) == 0 {
            currentPage = Int(offset / scrollView.frame.width)
        }
    }
}
