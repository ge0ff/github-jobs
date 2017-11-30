//
//  DetailViewController.swift
//  github-jobs
//
//  Created by Geoff Cornwall on 11/29/17.
//  Copyright © 2017 cornbits. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var detailWebView: WKWebView!
    
    func configureView() {
        if let detail = detailItem {
            if let webView = detailWebView {
                webView.load(URLRequest(url: URL(string: detail.url)!))
                detailDescriptionLabel.text = ""
            }
        }
        else {
            if let label = detailDescriptionLabel {
                detailWebView.isHidden = true
                label.text = "Select a job from the table"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: Job? {
        didSet {
            // Update the view.
            configureView()
        }
    }

}

