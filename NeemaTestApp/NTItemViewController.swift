//
//  NTItemViewController.swift
//  NeemaTestApp
//
//  Created by User on 12/1/16.
//  Copyright © 2016 Iegor Shapanov. All rights reserved.
//

import UIKit

class NTItemViewController: UIViewController {
    @IBOutlet weak var itemLabel: UILabel!
    var request: URLRequest?
    var jsonData: String = "" {
        willSet(json) {
            if let url = URL(string: json) {
                self.request = URLRequest(url: url)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let itemWV = self.itemLabel {
            itemWV.text = self.request?.url?.absoluteString
        }
    }
}
