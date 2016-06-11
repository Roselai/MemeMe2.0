//
//  SentMemesViewController.swift
//  memeMe1.0
//
//  Created by Shukti Shaikh on 6/7/16.
//  Copyright © 2016 Shukti Azad. All rights reserved.
//

import UIKit

class SentMemesViewController: UITableViewController {
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
}
