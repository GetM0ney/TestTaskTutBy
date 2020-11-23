//
//  TextView.swift
//  TutByMobile
//
//  Created by Владимир Лишаненко on 11/20/20.
//

import Foundation
import UIKit

class TextView: UIView {
    
    private let titleLabel = UILabel(frame: .zero)
    private let descriptionLabel = UILabel(frame: .zero)
    private let dateLabel = UILabel(frame: .zero)
    private let linkLabel = UILabel(frame: .zero)
    private var gestureRecognizer = UITapGestureRecognizer()
    private var linkString: String?
    
    private let leftOffset: CGFloat = 20
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    func configure() {
        isUserInteractionEnabled = true
        
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
        
        layout()
    }
    
    func layout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        linkLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            
            linkLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            linkLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            linkLabel.heightAnchor.constraint(equalToConstant: 21),
            linkLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            
            dateLabel.topAnchor.constraint(equalTo: linkLabel.bottomAnchor, constant: 10),
            dateLabel.heightAnchor.constraint(equalToConstant: 21),
            dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            dateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
        descriptionLabel.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
        linkLabel.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
        dateLabel.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
    }
    
    func reloadAllText(for index: Int) {
        let newText = FeedManager.shared.getInfo(at: index)
        titleLabel.text = newText.title!
        descriptionLabel.text = newText.textDescription!
        
        linkLabel.removeGestureRecognizer(gestureRecognizer)
        gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        linkLabel.addGestureRecognizer(gestureRecognizer)
        
        let attributedString = NSMutableAttributedString(string: "Подробнее")
        linkString = newText.link!
        attributedString.addAttribute(.link, value: newText.link!, range: NSRange(location: 0, length: 9))
        linkLabel.attributedText = attributedString
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        dateLabel.text = formatter.string(from: newText.date!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tap() {
        UIApplication.shared.open(URL(string: linkString!)!)
    }
}
