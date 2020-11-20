//
//  TextView.swift
//  TutByMobile
//
//  Created by Владимир Лишаненко on 11/20/20.
//

import Foundation
import UIKit

class TextView: UIStackView {
    
    private let titleLabel = UILabel(frame: .zero)
    private let descriptionLabel = UILabel(frame: .zero)
    private let dateLabel = UILabel(frame: .zero)
    private let linkLabel = UILabel(frame: .zero)
    private var gestureRecognizer = UITapGestureRecognizer()
    
    private let leftOffset: CGFloat = 20
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure() {
        isUserInteractionEnabled = true
        backgroundColor = .darkGray
        
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
        
        addArrangedSubview(titleLabel)
        addArrangedSubview(descriptionLabel)
        addArrangedSubview(linkLabel)
        addArrangedSubview(dateLabel)
        axis = .vertical
        spacing = 10
    }
    
    func setTitleText(for index: Int) {
        titleLabel.text = FeedManager.shared.getInfo(at: index).title!
        titleLabel.sizeToFit()
        
    }
    
    func setDescriptionText(for index: Int) {
        descriptionLabel.text = FeedManager.shared.getInfo(at: index).textDescription!
        descriptionLabel.sizeToFit()
    }
    
    func setLink(for index: Int) {
        
        linkLabel.removeGestureRecognizer(gestureRecognizer)
        gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        linkLabel.addGestureRecognizer(gestureRecognizer)
        
        let attributedString = NSMutableAttributedString(string: "Подробнее.")
        attributedString.addAttribute(.link, value: FeedManager.shared.getInfo(at: index).link!, range: NSRange(location: 0, length: 9))
        linkLabel.attributedText = attributedString
        linkLabel.sizeToFit()
    }
    
    func setDateText(for index: Int) {
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
        //  contentSize = CGSize(width: frame.width, height: dateLabel.frame.maxY + 20)
    }
    
    @objc func tap() {
        UIApplication.shared.open(URL(string: FeedManager.shared.getInfo(at: FeedManager.shared.getMaxIndex() - 10).link!)!)
    }
}
