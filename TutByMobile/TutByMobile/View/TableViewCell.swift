//
//  TableViewCell.swift
//  TutByMobile
//
//  Created by Владимир Лишаненко on 11/22/20.

import UIKit

class TableViewCell: UITableViewCell {
    static let identifier = "NewsTextID"
    
    
    var textView: TextView!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .darkGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCell(textView: TextView) {
        self.textView = textView
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textView)
        layout()
    }
    
    func layout() {
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: contentView.topAnchor),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
}
