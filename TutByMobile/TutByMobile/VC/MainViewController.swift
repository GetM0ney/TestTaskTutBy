//
//  ViewController.swift
//  TutByMobile
//
//  Created by Владимир Лишаненко on 11/16/20.
//

import UIKit
import CoreLocation
import FeedKit

class MainViewController: UIViewController {
    
    private var segment = UISegmentedControl()
    var feedView = FeedView()
    var textView = TextView()
    var refreshBar = UIRefreshControl()
    var tableView = UITableView()
    
    private var segmentYPos: CGFloat = 60
   
    override func viewDidLoad() {
        super.viewDidLoad()
       
        configure(mode: .new)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    func getImageView(view: FeedView, at index: Int) -> UIView {
        let imageView = UIImageView()
        imageView.image = FeedManager.shared.getImageArrayElement(at: index)
        return imageView
    }
    
    func configure(mode: WatchMode) {
        view.backgroundColor = .darkGray
        LocationManager.shared.delegate = self
        FeedManager.shared.delegate = self
        feedView.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        addSegmentControl()
        tableView = UITableView(frame: CGRect(x: 0, y: segment.frame.maxY, width: view.frame.width, height: view.frame.height - segment.frame.maxY), style: .plain)
        
        
        textView.configure()
        
        FeedManager.shared.configure() { success in
            self.feedView.reloadData(numberOfItems:FeedManager.shared.getMaxIndex(), itemAtIndex: self.getImageView)
        }
        view.addSubview(segment)
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
