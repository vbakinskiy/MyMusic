//
//  FooterView.swift
//  MyMusic
//
//  Created by Vyacheslav Bakinskiy on 6/24/20.
//  Copyright © 2020 Vyacheslav Bakinskiy. All rights reserved.
//

import UIKit

class FooterView: UIView {
    
    private var footerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.631372549, green: 0.6470588235, blue: 0.662745098, alpha: 1)
        return label
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let activityInd = UIActivityIndicatorView()
        activityInd.translatesAutoresizingMaskIntoConstraints = false
        activityInd.hidesWhenStopped = true
        return activityInd
    }()
    
    private func setupElements() {
        addSubview(footerLabel)
        addSubview(activityIndicator)
        
        activityIndicator.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        activityIndicator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        activityIndicator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        
        footerLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        footerLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 8).isActive = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showActivityIndicator() {
        activityIndicator.startAnimating()
        footerLabel.text = "Loading..."
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        footerLabel.text = ""
    }
}
