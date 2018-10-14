//
//  GenerateMemeViewController.swift
//  MemeMe
//
//  Created by John McCaffrey on 10/1/18.
//  Copyright © 2018 John McCaffrey. All rights reserved.
//

import UIKit

class GenerateMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var navToolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextfield: UITextField!
    @IBOutlet weak var bottomTextfield: UITextField!
    
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    var movementAllowed: Bool!
    
    var finishedScale: CGFloat = 1.0
    var newLocation: CGPoint = CGPoint(x: 0.0, y: 0.0)

    let memeTextDelegate = MemeTextFieldDelegate()
    
    var meme: Meme!
    var memeArrayLocation: Int = 0
    var memeEdit: Bool = false


    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextField(tf: topTextfield)
        setupTextField(tf: bottomTextfield)
        
        if meme != nil {
            memeEdit = true
            imagePickerView.image = meme.originalImage
            topTextfield.text = meme.topText
            bottomTextfield.text = meme.bottomText
            
            finishedScale = meme.finishedScale
            newLocation = meme.centerLocation

            imagePickerView.transform = imagePickerView.transform.translatedBy(x: newLocation.x, y: newLocation.y)
            imagePickerView.transform = imagePickerView.transform.scaledBy(x: finishedScale, y: finishedScale)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tapGesture.numberOfTapsRequired = 2
        
        imagePickerView.contentMode = .scaleAspectFit

        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        subscribeToKeyboardNotifications()
        
        if imagePickerView.image != nil {
            resetNavElements(buttonsEnabled: true)
        } else {
            resetNavElements(buttonsEnabled: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    //MARK: helper functions
    func setupTextField(tf: UITextField) {
        tf.defaultTextAttributes = [
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
            NSAttributedStringKey.font.rawValue: UIFont(name: "Impact", size: 40)!,
            NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
            NSAttributedStringKey.strokeWidth.rawValue: -3.0//neg. value allows for both stroke and fill
        ]
        tf.delegate = memeTextDelegate
        tf.textColor = UIColor.white
        tf.tintColor = UIColor.white
        tf.textAlignment = .center
    }
    
    func resetNavElements(buttonsEnabled: Bool){
        topTextfield.isEnabled = buttonsEnabled
        bottomTextfield.isEnabled = buttonsEnabled
        shareButton.isEnabled = buttonsEnabled

        movementAllowed = buttonsEnabled
        
        if !buttonsEnabled {
            imagePickerView.image = nil
            imagePickerView.backgroundColor = UIColor.darkGray
        } else {
            imagePickerView.backgroundColor = UIColor.clear
        }
    }
    
    func showHideToolbars(isHidden: Bool) {
        toolBar.isHidden = isHidden
        navToolBar.isHidden = isHidden
    }
    
    //MARK: Image items
    @IBAction func libraryAction(_ sender: UIBarButtonItem) {
        pickImageWithLibraryOrCamera(source: .photoLibrary)
    }
    
    @IBAction func cameraAction(_ sender: UIBarButtonItem) {
        pickImageWithLibraryOrCamera(source: .camera)
    }
    
    func pickImageWithLibraryOrCamera(source: UIImagePickerControllerSourceType) {
        if imagePickerView.image != nil {
            imagePickerView.transform = CGAffineTransform.identity
            
        }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func generateMemedImage() -> UIImage {
        //Hide toolbar and navbar
        showHideToolbars(isHidden: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //Show toolbar and navbar
        showHideToolbars(isHidden: false)
        
        return memedImage
    }
    
    //MARK: Actions
    func save(newMeme: UIImage) {
        // Create the meme
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //
        if memeEdit {
            
            meme.topText = topTextfield.text!
            meme.bottomText = bottomTextfield.text!
            meme.originalImage = imagePickerView.image!
            meme.memedImage = newMeme
            meme.finishedScale = finishedScale
            meme.centerLocation = newLocation
            
            appDelegate.memes[memeArrayLocation] = meme
            
        } else {
            meme = Meme(topText: topTextfield.text!, bottomText: bottomTextfield.text!, originalImage: imagePickerView.image!, memedImage: newMeme, finishedScale: finishedScale, centerLocation: newLocation)
            
            appDelegate.memes.append(meme)
        }
    }
    
    @IBAction func shareMeme(_ sender: UIBarButtonItem) {
        let image = generateMemedImage()
        
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        //check if device is ipad
        if UIDevice.current.userInterfaceIdiom == .pad {
            controller.modalPresentationStyle = UIModalPresentationStyle.popover
            controller.preferredContentSize = CGSize(width: 0, height: 0)
            controller.popoverPresentationController?.barButtonItem = sender
        }

        controller.completionWithItemsHandler = {
            (activity, success, items, error) in
            if success && error == nil {
//                print("completed \(activity as Any) \(success) \(items as Any) \(error as Any)")
                self.save(newMeme: image)
                self.dismiss(animated: true, completion: nil)
            }
            else if error != nil{
                //log the error
                print("error msg is: \(error as Any)")
            }
        }
        present(controller, animated: true)
    }

    @IBAction func cancelMeme(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil);
    }

    //MARK: Image Gestures
    @IBAction func pinch(_ sender: UIPinchGestureRecognizer) {
        if movementAllowed {
            if let view = sender.view {
                view.transform = view.transform.scaledBy(x: sender.scale, y: sender.scale)
                sender.scale = 1
            }
            //transform.a is the scaleX. Since x and y are being scaled the same, we only need the one value
            finishedScale = imagePickerView.transform.a
         }
    }
    
    @IBAction func pan(_ sender:UIPanGestureRecognizer) {
        if movementAllowed {
            let translation = sender.translation(in: self.view)
            if let view = sender.view {
                view.center = CGPoint(x:view.center.x + translation.x,
                                      y:view.center.y + translation.y)
                newLocation.x += translation.x
                newLocation.y += translation.y
            }
            sender.setTranslation(CGPoint.zero, in: self.view)
        }
    }
    
    @IBAction func tap(_ sender:UITapGestureRecognizer) {
        if movementAllowed {
            if let view = sender.view {
                view.transform = CGAffineTransform.identity
                view.center = CGPoint(x:self.view.center.x, y:self.view.center.y)
                finishedScale = imagePickerView.transform.a
                newLocation.x = 0.0
                newLocation.y = 0.0
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if imagePickerView.image != nil {
            movementAllowed = true
        } else {
            movementAllowed = false
        }
    }
    
    //MARK: Keyboard items
    @objc func keyboardWillShow(_ notification:Notification){
        //verify it the bottom textfield before shifting keyboard
        if bottomTextfield.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification){
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification)-> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    //MARK: default memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
