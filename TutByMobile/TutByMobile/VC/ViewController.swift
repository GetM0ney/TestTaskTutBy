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
    
    var segment: UISegmentedControl!
    var feedView: FeedView?
    var textView: TextView?
    
    
    private var segmentYPos: CGFloat = 60
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        LocationManager.shared.delegate = self
        FeedManager.shared.delegate = self
        addSegment()
        feedView = FeedView(frame: CGRect(x: 0, y: segment.frame.maxY, width: view.frame.width, height: view.frame.height / 2))
        feedView!.delegate = self
        textView = TextView(frame: CGRect(x: 0, y: self.feedView!.frame.maxY, width: self.view.frame.width, height: view.frame.height - feedView!.frame.maxY), textContainer: nil)
        textView!.configure()
        textView?.backgroundColor = .darkGray
        FeedManager.shared.configure() { success in
            self.feedView?.reloadData(numberOfItems:FeedManager.shared.getMaxIndex() , itemAtIndex: self.getImageView)
        }
        view.addSubview(feedView!)
        view.addSubview(textView!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    func addSegment() {
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
        view.addSubview(segment)
    }
    
    func getImageView(view: FeedView, at index: Int) -> UIView {
        let imageView = UIImageView()
        imageView.image = FeedManager.shared.getImageArrayElement(at: index)
        return imageView
    }
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            print("Ilya SOsi0")
        case 1:
            print("Ilya SOsi1")
        default:
            break
        }
    }
}

extension ViewController: LocationManagerDelegate, FeedViewDelegate, FeedManagerDelegate {
    func updateImages() {
        self.feedView?.reloadData(numberOfItems:FeedManager.shared.getMaxIndex() , itemAtIndex: self.getImageView)
    }
    
    func pageDidChange() {
        textView!.reloadAllText(for: feedView!.currentPage)
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
