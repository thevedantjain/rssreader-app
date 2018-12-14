//
//  FeedCheck.swift
//  rssreader
//
//  Created by Vedant Jain on 14/12/18.
//  Copyright © 2018 Vedant Jain. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct Source {
    
    var title:String
    var description: String
    var link: String
    var isSelected: Bool
    
}

class FeedCheck: UITableViewController {
    
    let sourceArray: [Source] = [Source.init(title: "Apple Dev News", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur", link: "https://developer.apple.com/news", isSelected: true), Source.init(title: "The Verge", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur",  link: "https://theverge.com", isSelected: true), Source.init(title: "Times of India", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur", link: "https://timesofindia.com", isSelected: true)]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //hide navigation bar
        //        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        //core data shit
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Source", in: context)
        let newSource = NSManagedObject(entity: entity!, insertInto: context)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.allowsSelection = true
        
        tableView.register(sourceCell.self, forCellReuseIdentifier: "checkbox")
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return sourceArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: sourceCell = tableView.dequeueReusableCell(withIdentifier: "checkbox", for: indexPath) as! sourceCell
        cell.headLabel.text = sourceArray[indexPath.item].title
        cell.subtextLabel.text = sourceArray[indexPath.item].description
        cell.sourceLabel.text = sourceArray[indexPath.item].link
//        let switchView = UISwitch(frame: .zero)
        cell.switchView.setOn(false, animated: true)
        cell.switchView.tag = indexPath.row // for detect which row switch Changed
        cell.switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        cell.accessoryView = cell.switchView
        
        
        return cell
    }
    
    @objc func switchChanged(_ sender : UISwitch!){
        
        let currentCell: sourceCell = sender.superview as! sourceCell
        
        if (currentCell.isSelected == true) {
            currentCell.isSelected = false
            return
        }
        currentCell.isSelected = true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //toggle isSelected
//        let currentCell: sourceCell = tableView.cellForRow(at: indexPath) as! sourceCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //adjust height
        return 230.0
    }
    
}
