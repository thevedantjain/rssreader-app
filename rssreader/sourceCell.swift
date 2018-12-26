//
//  sourceCell.swift
//  rssreader
//
//  Created by Vedant Jain on 14/12/18.
//  Copyright © 2018 Vedant Jain. All rights reserved.
//

import Foundation
import UIKit

class sourceCell: UITableViewCell {
    
    var headLabel: UILabel = {
        let headLabel = UILabel()
        headLabel.textAlignment = .left
        headLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        headLabel.translatesAutoresizingMaskIntoConstraints = false
        headLabel.numberOfLines = 2
        headLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        return headLabel
    }()
    
    var sourceLabel: UILabel = {
        let sourceLabel = UILabel()
        sourceLabel.font = UIFont.systemFont(ofSize: 16.0)
        sourceLabel.textAlignment = .left
        sourceLabel.translatesAutoresizingMaskIntoConstraints = false
        sourceLabel.numberOfLines = 0
        sourceLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        return sourceLabel
    }()
    
    var subtextLabel: UILabel = {
        let subtextLabel = UILabel()
        subtextLabel.textAlignment = .left
        subtextLabel.translatesAutoresizingMaskIntoConstraints = false
        subtextLabel.numberOfLines = 5
        subtextLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        return subtextLabel
    }()
    
    var switchView: UISwitch = {
        let switchView = UISwitch()
        return switchView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // code common to all your cells goes here
        addSubview(switchView)
        addSubview(headLabel)
        addSubview(sourceLabel)
        addSubview(subtextLabel)
        
        headLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: -140).isActive = true
        headLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        headLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 10).isActive = true
        headLabel.rightAnchor.constraint(equalTo: switchView.leftAnchor, constant: -10).isActive = true
        
        sourceLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: -100).isActive = true
        sourceLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        sourceLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 10).isActive = true
        sourceLabel.rightAnchor.constraint(equalTo: switchView.leftAnchor, constant: -10).isActive = true
        
        switchView.topAnchor.constraint(equalTo: self.topAnchor, constant: -200).isActive = true
        
        subtextLabel.topAnchor.constraint(equalTo: headLabel.topAnchor, constant: 180).isActive = true
        subtextLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        subtextLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 10).isActive = true
        subtextLabel.rightAnchor.constraint(equalTo: switchView.leftAnchor, constant: -10).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
