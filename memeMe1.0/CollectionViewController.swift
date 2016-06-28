//
//  CollectionViewController.swift
//  memeMe2.0
//
//  Created by Shukti Shaikh on 6/9/16.
//  Copyright © 2016 Shukti Azad. All rights reserved.
//

import UIKit
import Foundation

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
    
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBarHeight = navigationController!.navigationBar.frame.size.height
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        collectionView!.contentInset = UIEdgeInsets(top: (navBarHeight + statusBarHeight), left: 0,bottom: 0,right: 0)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView!.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as!CustomCollectionViewCell
        let image = memes[indexPath.item].memeImage
        cell.imageView.image = image
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowMemeCV" {
            if let cell = sender as? CustomCollectionViewCell, indexPath = collectionView?.indexPathForCell(cell) {
                let selectedMeme = memes[indexPath.item]
                let detailViewController = segue.destinationViewController as! MemeDetailViewController
                detailViewController.meme = selectedMeme
            }
        }
    }
    
}
