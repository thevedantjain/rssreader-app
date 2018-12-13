//
//  FeedCheck.swift
//  rssreader
//
//  Created by Vedant Jain on 14/12/18.
//  Copyright © 2018 Vedant Jain. All rights reserved.
//

import Foundation
import UIKit

class FeedCheck: UITableViewController {
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //hide navigation bar
        //        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        //fetch XML data
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.allowsSelection = true
        
        tableView.register(linkCell.self, forCellReuseIdentifier: "checkbox")
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //        tableView.deselectRow(at: indexPath, animated: true)
        //        let cell = tableView.cellForRow(at: indexPath) as! linkCell
        //
        //        tableView.beginUpdates()
        //        cell.subtextLabel.numberOfLines = (cell.subtextLabel.numberOfLines == 0) ? 3 : 0
        //
        //        cellStates?[indexPath.row] = (cell.subtextLabel.numberOfLines == 0) ? .expanded : .collapsed
        //
        //        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 230.0
    }
    
}
