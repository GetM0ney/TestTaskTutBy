//
//  MainTableView+Protocols.swift
//  TutByMobile
//
//  Created by Владимир Лишаненко on 11/22/20.
//

import UIKit
import Foundation

extension MainViewController: LocationManagerDelegate, FeedViewDelegate, FeedManagerDelegate {
    func updateImages() {
        self.feedView.reloadData(numberOfItems: FeedManager.shared.getMaxIndex(), itemAtIndex: self.getImageView)
    }
    
    func pageDidChange() {
        textView.reloadAllText(for: feedView.currentPage)
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

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return feedView
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell
        cell?.updateCell()
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        feedView.frame.height
    }
}
