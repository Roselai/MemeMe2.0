//
//  MemeDetailViewController.swift
//  memeMe2.0
//
//  Created by Shukti Shaikh on 6/9/16.
//  Copyright © 2016 Shukti Azad. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    
    var meme: Meme!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let image = meme.memeImage
        imageView.image = image
        self.view.addSubview(imageView)
        
    }
}
