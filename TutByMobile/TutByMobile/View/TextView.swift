//
//  TextView.swift
//  TutByMobile
//
//  Created by Владимир Лишаненко on 11/20/20.
//

import Foundation
import UIKit

class TextView: UITextView, UITextViewDelegate {
    
    private let titleLabel = UILabel(frame: .zero)
    private let descriptionLabel = UILabel(frame: .zero)
    private let dateLabel = UILabel(frame: .zero)
    private let linkLabel = UILabel(frame: .zero)
    
    private let leftOffset: CGFloat = 20
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: nil)
        
    }
    func configure() {
        isEditable = false
        isScrollEnabled = true
        isUserInteractionEnabled = true
        dataDetectorTypes = .link
        
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        titleLabel.font = .systemFont(ofSize: 25)
        addSubview(titleLabel)
        
        descriptionLabel.textColor = .lightText
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .systemFont(ofSize: 16)
        addSubview(descriptionLabel)
        
        linkLabel.textColor = .link
        linkLabel.textAlignment = .left
        linkLabel.numberOfLines = 0
        linkLabel.isUserInteractionEnabled = true
        linkLabel.font = .italicSystemFont(ofSize: 14)
        addSubview(linkLabel)
        
        dateLabel.textColor = .lightGray
        dateLabel.textAlignment = .left
        dateLabel.font = .italicSystemFont(ofSize: 18)
        addSubview(dateLabel)
    }
    
    func setTitleText(for index: Int) {
        titleLabel.frame = CGRect(x: leftOffset, y: 10, width: frame.size.width - leftOffset * 2, height: 10)
        titleLabel.text = FeedManager.shared.getInfo(at: index).title!
        titleLabel.sizeToFit()
    }
    
    func setDescriptionText(for index: Int) {
        descriptionLabel.frame = CGRect(x: leftOffset, y: titleLabel.frame.maxY + 10, width: frame.size.width - leftOffset * 2, height: 10)
        descriptionLabel.text = FeedManager.shared.getInfo(at: index).description!
        descriptionLabel.sizeToFit()
    }
    
    func setLink(for index: Int) {
        linkLabel.frame = CGRect(x: leftOffset, y: descriptionLabel.frame.maxY + 10, width: frame.size.width - leftOffset * 2, height: 10)
        linkLabel.text = FeedManager.shared.getInfo(at: index).link!
        linkLabel.sizeToFit()
    }
    
    func setDateText(for index: Int) {
        dateLabel.frame = CGRect(x: leftOffset, y: linkLabel.frame.maxY + 10, width: frame.size.width - leftOffset * 2, height: 10)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        dateLabel.text = formatter.string(from: FeedManager.shared.getInfo(at: index).date!)
        dateLabel.sizeToFit()
    }
    
    func reloadAllText(for index: Int) {
        setTitleText(for: index)
        setDescriptionText(for: index)
        setLink(for: index)
        setDateText(for: index)
        contentSize = CGSize(width: frame.width, height: dateLabel.frame.maxY + 20)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
