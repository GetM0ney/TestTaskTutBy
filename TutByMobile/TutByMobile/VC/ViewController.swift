//
//  ViewController.swift
//  TutByMobile
//
//  Created by Владимир Лишаненко on 11/16/20.
//

import UIKit
import CoreLocation
import FeedKit

class ViewController: UIViewController {
    
    var segment = UISegmentedControl()
    var feedView = FeedView()
    var textView = TextView()
    var scrollView = UIScrollView()
    var contentView = UIView()
    
    private var segmentYPos: CGFloat = 60
   
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(mode: .new)
        layout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    func addSegmentControl() {
        let items = ["New", "Recent"]
        segment = UISegmentedControl(items: items)
        segment.center = CGPoint(x: view.bounds.midX, y: segmentYPos)
        segment.selectedSegmentTintColor = .lightGray
        segment.backgroundColor = .darkGray
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(indexChanged), for: .valueChanged)
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        segment.setTitleTextAttributes(titleTextAttributes, for: .normal)
        let titleTextAttributes1 = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segment.setTitleTextAttributes(titleTextAttributes1, for: .selected)
        segment.clearBG()
    }
    
    func getImageView(view: FeedView, at index: Int) -> UIView {
        let imageView = UIImageView()
        imageView.image = FeedManager.shared.getImageArrayElement(at: index)
        return imageView
    }
    
    func layout() {
        contentView.frame = scrollView.bounds
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            segment.topAnchor.constraint(equalTo: contentView.topAnchor, constant: segmentYPos),
            segment.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            segment.heightAnchor.constraint(equalToConstant: 31),
            
            feedView.topAnchor.constraint(equalTo: segment.bottomAnchor),
            feedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            feedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            feedView.heightAnchor.constraint(equalToConstant: view.frame.height / 2),
            
            textView.topAnchor.constraint(equalTo: feedView.bottomAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }
    
    func configure(mode: WatchMode) {
        
        view.backgroundColor = .darkGray
        LocationManager.shared.delegate = self
        FeedManager.shared.delegate = self
        feedView.delegate = self
        scrollView.delegate = self
        
        scrollView.bouncesZoom = false
        scrollView.delaysContentTouches = false
        addSegmentControl()
        textView.configure()
        
        FeedManager.shared.configure(mode: mode) { success in
            
            self.feedView.reloadData(numberOfItems:FeedManager.shared.getMaxIndex(), itemAtIndex: self.getImageView)
        }
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(segment)
        contentView.addSubview(feedView)
        contentView.addSubview(textView)
        
        feedView.isUserInteractionEnabled = true
        feedView.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        segment.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            configure(mode: .new)
            FeedManager.shared.setMode(mode: .new)
            feedView.scrollTo(page: 0)
            
        case 1:
            configure(mode: .recent)
            FeedManager.shared.setMode(mode: .recent)
            feedView.scrollTo(page: 0)
        default:
            break
        }
    }
}

extension ViewController: LocationManagerDelegate, FeedViewDelegate, FeedManagerDelegate {
    func updateImages() {
        self.feedView.reloadData(numberOfItems: FeedManager.shared.getMaxIndex(), itemAtIndex: self.getImageView)
    }
    
    func pageDidChange() {
        textView.reloadAllText(for: feedView.currentPage)
        let contentSize = CGSize(width: view.frame.width, height: textView.frame.maxY + 16)
        let size = view.frame.size
        if contentSize.height > size.height {
            contentView.frame.size = contentSize
            self.scrollView.isScrollEnabled = true
        } else {
            contentView.frame.size = size
            self.scrollView.isScrollEnabled = false
        }
        scrollView.contentSize = contentView.frame.size
    }
    
    func updateUI(status: Bool) {
        if status {
            let alert = UIAlertController(title: "Error", message: "You're not from Belarus", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                exit(-1)
            }))
            self.present(alert, animated: false, completion: nil)
        } 
    }
    
    
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let offsetX = scrollView.contentOffset.x
        if offsetY < offsetX {
            self.scrollView.isScrollEnabled = false
        }
    }
}
