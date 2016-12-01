//
//  ViewController.swift
//  NeemaTestApp
//
//  Created by User on 12/1/16.
//  Copyright © 2016 Iegor Shapanov. All rights reserved.
//

import UIKit
import QuartzCore

class NTRootViewController: UITableViewController, NTFeedParserDelegate{
    
    var items: [[String:String]]?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.request()
    }
    
    // Fetch data 
    
    let headerImageString = "http://lorempixel.com/400/200/abstract/"
    
    let urlString = "http://jsonplaceholder.typicode.com/users"

    func request() {
        let feedParser = NTJsonParser(feedURL: urlString);
        feedParser.delegate = self
        feedParser.parse()
    }

    // TableView Data Source 
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let objects = self.items {
            return objects.count
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> NTCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! NTCell
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    // MARK: Cell managment 
    
    func configureCell(_ cell: NTCell, atIndexPath indexPath: IndexPath) {
        
        guard let item = self.items?[indexPath.row] else {return}
        if let itemText = item["name"] {
            cell.userName?.text = itemText
        } else {
            cell.userName?.text = "Downloading ... "
        }
        
        cell.data = item["data"]
        
        cell.userPicture?.image = UIImage(named: "placeholder.png")
        
        cell.userPicture?.downloadedFrom(link: "http://lorempixel.com/400/200/people/")
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 210.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = self.tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! NTHeaderCell
        headerView.headerPicture?.downloadedFrom(link: headerImageString)

        return headerView
    }
    
    // MARK: Feed parser Delegate methods
    
    func feedParser(_ parser: NTJsonParser, successfullyParsedURL url: String, withObjects: [[String:String]]) {
        self.items = withObjects
        self.tableView.reloadData()
    }
    
    func feedParserParsingAborted(_ parser: NTJsonParser) {
        
    }
    
    func feedParser(_ parser: NTJsonParser, parsingFailedReason reason: String) {
        
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let itemVC = segue.destination as! NTItemViewController
        let json = (sender as! NTCell).data
        itemVC.jsonData = json!
    }
}

