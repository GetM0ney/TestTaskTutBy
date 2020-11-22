//
//  TableViewCell.swift
//  TutByMobile
//
//  Created by Владимир Лишаненко on 11/22/20.

import UIKit

class TableViewCell: UITableViewCell {
    static let identifier = "NewsTextID"

    private var textView: TextView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textView = TextView(frame: .zero)
        contentView.addSubview(textView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCell() {
        
    }
    
}
