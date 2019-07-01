//
//  DetailViewController.swift
//  Blog-Reader
//
//  Created by Sean Higgins on 6/24/19.
//  Copyright © 2019 Sean Higgins. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

    @IBOutlet weak var web_view: WKWebView!
    
    func configureView() {
        // Update the user interface for the detail item.

        if let detail = detailItem {
            
             self.title = detail.value(forKey: "title") as! String
            
            if let blog_web_view = web_view {
                blog_web_view.loadHTMLString(detail.value(forKey: "content") as! String, baseURL: nil)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }

    var detailItem: Event? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

