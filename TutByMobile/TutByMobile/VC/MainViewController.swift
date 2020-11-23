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
    var tableView: UITableView!
    
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
        tableView.reloadData()
        return imageView
    }
    
    func configure(mode: WatchMode) {
        view.backgroundColor = .darkGray
        LocationManager.shared.delegate = self
        FeedManager.shared.delegate = self
        feedView.delegate = self
        

        addSegmentControl()
        textView.configure()
        tableView = UITableView(frame: CGRect(x: 0, y: segment.frame.maxY, width: view.frame.width, height: view.frame.height - segment.frame.maxY), style: .grouped)
        tableView.backgroundColor = .darkGray
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)

        
        FeedManager.shared.configure() { success in
            self.feedView.reloadData(numberOfItems:FeedManager.shared.getMaxIndex(), itemAtIndex: self.getImageView)
            self.tableView.reloadData()
        }
        
        view.addSubview(segment)
        view.addSubview(tableView)
        layout()
        
    }
    
    func addSegmentControl() {
        let items = ["New", "Recent"]
        segment = UISegmentedControl(items: items)
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
            
            
        case 1:
            configure(mode: .recent)
            FeedManager.shared.setMode(mode: .recent)
            
        default:
            break
        }
    }
    
    func layout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        segment.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segment.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            segment.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: segment.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
