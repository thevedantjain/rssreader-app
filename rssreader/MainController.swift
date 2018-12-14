//
//  MainController.swift
//  rssreader
//
//  Created by Vedant Jain on 05/12/18.
//  Copyright © 2018 Vedant Jain. All rights reserved.
//

import UIKit
import SafariServices

class MainController: UITableViewController {
    
    private var rssItems: [RSSItem]? = []
    private var cellStates: [CellState]?
    
    private let linkCellID = "linkCell"
    
    private func fetchData() {
        let feedParser = FeedParser()
        feedParser.parseFeed(url: "https://developer.apple.com/news/rss/news.rss") { (rssItems) in
            self.rssItems = rssItems
            self.cellStates = Array(repeating: .collapsed, count: rssItems.count)
            
            OperationQueue.main.addOperation {
                //reload view
//                print("dev apple news")
                self.tableView.reloadSections(IndexSet(integer: 0), with: .left)
            }
            
        }

        feedParser.parseFeed(url: "https://www.theverge.com/rss/index.xml") { (rssItems) in

            self.rssItems = rssItems
            self.cellStates = Array(repeating: .collapsed, count: rssItems.count)

            OperationQueue.main.addOperation {
                //reload view
//                print("the verge")
//                self.tableView.reloadSections(IndexSet(integer: 0), with: .left)
            }

        }

        feedParser.parseFeed(url: "https://timesofindia.indiatimes.com/rssfeedstopstories.cms") { (rssItems) in

            self.rssItems = rssItems
            self.cellStates = Array(repeating: .collapsed, count: rssItems.count)

//            self.rssItems.sort(by: <#T##(RSSItem, RSSItem) throws -> Bool#>)

            OperationQueue.main.addOperation {
                //reload view
//                print("toi")
                self.tableView.reloadSections(IndexSet(integer: 0), with: .left)
            }

        }
        
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //hide navigation bar
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        //fetch XML data
        fetchData()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.allowsSelection = true
        
        tableView.register(linkCell.self, forCellReuseIdentifier: linkCellID)
        
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        guard var rssItems = rssItems else {
            return 0
        }
        
        rssItems = rssItems.sorted(by: { $0.pubDate.compare($1.pubDate) == .orderedAscending })
        
        // rssItems
        return rssItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: linkCell = tableView.dequeueReusableCell(withIdentifier: linkCellID, for: indexPath) as! linkCell
        cell.headLabel.text = rssItems?[indexPath.item].title ?? "title"
//        cell.sourceLabel.text = rssItems?[indexPath.item].source ?? "source"
        cell.sourceLabel.text = "www.example.com"
//        print(cell.sourceLabel.text as Any)
        cell.subtextLabel.text = rssItems?[indexPath.item].description ?? "description"
        cell.link = rssItems?[indexPath.item].link ?? "https://apple.com"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, HH:mm, dd MMM"
        let dateString = formatter.string(from: (rssItems?[indexPath.item].pubDate)!)
        cell.dateLabel.text = dateString
        
        return cell
    
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
        print("tapped")
        let urlString:String = rssItems?[indexPath.item].link as! String
        let url = URL(string: urlString)
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        let safariVC = SFSafariViewController(url: url ?? URL(string: "https://www.apple.com")!, configuration: config)
        present(safariVC, animated: true, completion: nil)
    }
    
    //when user dismissed safari view controller
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230.0
    }
    
}

