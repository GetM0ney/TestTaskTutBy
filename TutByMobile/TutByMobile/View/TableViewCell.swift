//
//  TableViewCell.swift
//  TutByMobile
//
//  Created by Владимир Лишаненко on 11/22/20.

import UIKit

class TableViewCell: UITableViewCell {
    static let identifier = "NewsTextID"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .darkGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCell(textView: TextView) {
        
        contentView.addSubview(textView)
    }
    
}
