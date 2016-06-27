//
//  ViewController.swift
//  memeMe1.0
//
//  Created by Shukti Shaikh on 5/11/16.
//  Copyright © 2016 Shukti Azad. All rights reserved.
//

import UIKit

protocol viewControllerDelegate{
    func myVCDidFinish(controller:ViewController, editedMeme: Meme)
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    //MARK: OUTLETS
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var saveMemeButton: UIBarButtonItem!

    
    //MARK: VARIABLES
    var keyboardHidden = true
    var meme: Meme!
    var memeIndex: Int?
    var delegate:viewControllerDelegate? = nil
    
    //MARK: VIEW FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextField(topText)
        setupTextField(bottomText)
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        
        shareButton.enabled = false
        saveMemeButton.enabled = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        
        if (meme != nil)  {
            shareButton.enabled = true
            saveMemeButton.enabled = true
            
            imagePickerView.image = meme.image
            topText.text = meme.topText
            bottomText.text = meme.bottomText
        }
        
        else {
            return
        }
        
        }
    
    
    override func viewWillDisappear(animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }
    
    
    // MARK: UIIMAGEPICKERCONTROLLER
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.contentMode = .ScaleAspectFit
            imagePickerView.image = image
        }
        dismissViewControllerAnimated(true, completion: nil)
        shareButton.enabled = true
        saveMemeButton.enabled = true
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: TEXTFIELD
    
    func setupTextField(textField: UITextField) {
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "impact", size: 35)!,
            NSStrokeWidthAttributeName : -3.0
        ]
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .Center
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM"{
            if textField .isEqual(bottomText) {
                subscribeToKeyboardNotifications()
            }
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: KEYBOARD FUNCTIONS
    func keyboardWillShow(notification: NSNotification) {
        if(keyboardHidden){
            if self.view.frame.origin.y == 0.0{
                self.view.frame.origin.y -= getKeyboardHeight(notification)
                keyboardHidden = false
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if(!keyboardHidden){
            self.view.frame.origin.y += getKeyboardHeight(notification)
            keyboardHidden = true
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    //MARK: SUBSCRIPTIONS
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow)    , name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide)    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    
    //MARK: MEME FUNCTIONS
    func generateMemedImage() -> UIImage {
        
        hideToolBars(true)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
                                     afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        hideToolBars(false)

        return memedImage
    }
    
    func save() {
        
        meme = Meme(topText: topText.text!, bottomText: bottomText.text!, image: imagePickerView.image, memeImage: generateMemedImage())
        
        if (delegate != nil) {
            
            delegate!.myVCDidFinish(self, editedMeme: meme)
            
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(memeIndex!)
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.insert(meme, atIndex: memeIndex!)
        }
        else {

            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
        }
    }
    
    func hideToolBars(flag:Bool){
        navBar.hidden = flag
        bottomToolbar.hidden = flag
    }
    
    //MARK: ACTIONS
    func pickAnImage (source: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        pickAnImage(.PhotoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        pickAnImage(.Camera)
    }
    
    
    @IBAction func shareMeme(sender: AnyObject) {
        let image = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        controller.completionWithItemsHandler = {
            (s: String?, ok: Bool, items: [AnyObject]?, err:NSError?) -> Void in
            if ok{
                self.save()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func cancelMeme(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func saveMemeButton(sender: UIBarButtonItem) {
        save()
        self.dismissViewControllerAnimated(true, completion: {
        })
    }
    
    
    
}





