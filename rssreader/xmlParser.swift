//
//  rssParser.swift
//  rssreader
//
//  Created by Vedant Jain on 06/12/18.
//  Copyright © 2018 Vedant Jain. All rights reserved.
//

import Foundation

struct RSSItem {
    var title: String
    var source: String
    var description: String
    var pubDate: Date
    var link: String
}

// download xml from a server
// parse xml to foundation objects
// call back

class FeedParser: NSObject, XMLParserDelegate
{
    private var rssItems: [RSSItem] = []
    private var currentElement = ""
    
    private var currentTitle: String = "" {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentDescription: String = "" {
        didSet {
            currentDescription = currentDescription.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentPubDate: Date = Date(timeIntervalSinceReferenceDate: -1789.0) as Date {
        didSet {
            currentPubDate = Date(timeInterval: 0.0, since: Date.init()) as Date
        }
    }
    
    private var currentLink: String = "" {
        didSet {
            currentLink = currentLink.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var parserCompletionHandler: (([RSSItem]) -> Void)?
    
    func parseFeed(url: String, completionHandler: (([RSSItem]) -> Void)?)
    {
        self.parserCompletionHandler = completionHandler
        
        let request = URLRequest(url: URL(string: url)!)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    print(error.localizedDescription)
                }
                
                return
            }
            
            /// parse our xml data
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        
        task.resume()
    }
    
    // MARK: - XML Parser Delegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        currentElement = elementName
        if (currentElement == "item") || (currentElement == "entry") {
            currentTitle = ""
            currentDescription = ""
            currentPubDate = Date(timeInterval: 0.0, since: Date.init())
            currentLink = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        var i = 0
        
        switch currentElement {
            case "title": currentTitle += string
            case "description", "content" :
                if (string.trimmingCharacters(in: CharacterSet.whitespaces).count < 5) {
                    break
                }
                if (currentElement == "content" && i == 0) {
                    print("string", string)
                    let startIndex: String.Index = string.endIndex(of: "<p") ?? string.startIndex
                    let endIndex: String.Index = string.index(of: "</p>") ?? string.endIndex
                    if (string.count > 15) {
                        let first = string.index(startIndex, offsetBy: 13)
                        currentDescription += string[first..<endIndex]
                    }
                    else {
                        currentDescription += string[startIndex..<endIndex]
                    }
                }
                else {
                    currentDescription += string
                }
                i = i+1
            break
            case "pubDate" :
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                
                // toi and apple format
                dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
//                print("date: ", string)
                let date = dateFormatter.date(from: string) ?? Date(timeIntervalSinceReferenceDate: 0.0)
//                print("pubDate: ", dateFormatter.string(from: date))
                currentPubDate = date
                break
            case "published" :
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                // verge format
                dateFormatter.dateFormat = "yyyy-MM-ddThh:mm:ss-ZZZZ"
                let date = dateFormatter.date(from: string) ?? Date(timeIntervalSinceReferenceDate: -12389.0)
//                print("published: ", dateFormatter.string(from: date))
                currentPubDate = date
                break
            case "link" : currentLink += string
            case "id" : currentLink += string
            default: break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName == "item") || (elementName == "entry") {
            let rssItem = RSSItem(title: currentTitle, source: "", description: currentDescription, pubDate: currentPubDate, link: currentLink)
            self.rssItems.append(rssItem)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(rssItems)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error)
    {
        print(parseError.localizedDescription)
    }
    
}

// finding substring

extension StringProtocol where Index == String.Index {
    func index(of string: Self, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    func endIndex(of string: Self, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.upperBound
    }
    func indexes(of string: Self, options: String.CompareOptions = []) -> [Index] {
        var result: [Index] = []
        var start = startIndex
        while start < endIndex,
            let range = self[start..<endIndex].range(of: string, options: options) {
                result.append(range.lowerBound)
                start = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
    func ranges(of string: Self, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var start = startIndex
        while start < endIndex,
            let range = self[start..<endIndex].range(of: string, options: options) {
                result.append(range)
                start = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}

// for int to string.index conversion

extension String {
    subscript (index: Int) -> Character {
        let charIndex = self.index(self.startIndex, offsetBy: index)
        return self[charIndex]
    }
    
    subscript (range: Range<Int>) -> Substring {
        let startIndex = self.index(self.startIndex, offsetBy: range.startIndex)
        let stopIndex = self.index(self.startIndex, offsetBy: range.startIndex + range.count)
        return self[startIndex..<stopIndex]
    }
    
}
