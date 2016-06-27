//
//  MemeTableViewController.swift
//  memeMe2.0
//
//  Created by Shukti Shaikh on 6/8/16.
//  Copyright © 2016 Shukti Azad. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBarHeight = navigationController!.navigationBar.frame.size.height
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        tableView.contentInset = UIEdgeInsets(top: (navBarHeight + statusBarHeight), left: 0,bottom: 0,right: 0)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as UITableViewCell!
        let meme = self.memes[indexPath.row]
        
        // Set the name and image
        cell.textLabel?.text = meme.topText + " " + meme.bottomText
        cell.imageView?.image = meme.memeImage
        
        // If the cell has a detail label, we will put the evil scheme in.
        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = meme.bottomText
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowMeme" {
            if let row = tableView.indexPathForSelectedRow?.row {
                let selectedMeme = memes[row]
                let memeIndex = row
                let detailViewController = segue.destinationViewController as! MemeDetailViewController
                detailViewController.meme = selectedMeme
                detailViewController.memeIndex = memeIndex
            }
        }
        
    }
    
}





