//
//  MemeDetailViewController.swift
//  memeMe2.0
//
//  Created by Shukti Shaikh on 6/9/16.
//  Copyright © 2016 Shukti Azad. All rights reserved.
//

import UIKit


class MemeDetailViewController: UIViewController, viewControllerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    
    
    var meme: Meme!
    var memeIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let image = meme.memeImage
        imageView.image = image
        view.addSubview(imageView)
        
    }
    
  
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditMeme" {
                let memeEditor = segue.destinationViewController as! ViewController
                memeEditor.meme = meme
                memeEditor.memeIndex = memeIndex
                memeEditor.delegate = self
            }
        }
    
    func myVCDidFinish(controller: ViewController, editedMeme: Meme) {
        meme = editedMeme
       controller.navigationController?.popViewControllerAnimated(true)
        
    }

}
