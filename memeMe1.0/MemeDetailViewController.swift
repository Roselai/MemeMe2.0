//
//  MemeDetailViewController.swift
//  memeMe2.0
//
//  Created by Shukti Shaikh on 6/9/16.
//  Copyright © 2016 Shukti Azad. All rights reserved.
//

import UIKit


class MemeDetailViewController: UIViewController, MemeEditorViewControllerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    
    
    var meme: Meme!
    var memeIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
    }
    
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let image = meme.memeImage
        imageView.image = image
        
        
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditMeme" {
            let memeEditor = segue.destinationViewController as! MemeEditorViewController
            memeEditor.meme = meme
            memeEditor.memeIndex = memeIndex
            memeEditor.delegate = self
        }
    }
    
    func myVCDidFinish(controller: MemeEditorViewController, editedMeme: Meme) {
        meme = editedMeme
        controller.navigationController?.popViewControllerAnimated(true)
        
    }
    
}
