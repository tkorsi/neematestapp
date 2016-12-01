//
//  ViewController.swift
//  NeemaTestApp
//
//  Created by User on 12/1/16.
//  Copyright © 2016 Iegor Shapanov. All rights reserved.
//

import UIKit

class NTRootViewController: UITableViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        request()
    }
    
    // Fetch data 
    
    func request() {
        let URL = Foundation.URL(string: "https://www.wantedly.com/projects.xml")
        let feedParser = MWFeedParser(feedURL: URL);
        feedParser.delegate = self
        feedParser.parse()
    }

    // TableView Data Source 
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "FeedCell")
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    // Cell managment 
    
    func configureCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath) {
//        let item = self.items[indexPath.row] as MWFeedItem
        cell.textLabel?.text = "Hello"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14.0)
        cell.textLabel?.numberOfLines = 0
//        
//        let projectURL = item.link.componentsSeparatedByString("?")[0]
//        let imgURL: URL? = URL(string: projectURL + "/cover_image?style=200x200#")
//        cell.imageView?.contentMode = UIViewContentMode.scaleAspectFit
//        cell.imageView?.setImageWithURL(imgURL, placeholderImage: UIImage(named: "logo.png"))
    }
}

