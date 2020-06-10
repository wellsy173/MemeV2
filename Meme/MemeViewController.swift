//
//  ViewController.swift
//  Meme
//
//  Created by Simon Wells on 2020/4/27.
//  Copyright © 2020 Simon Wells. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var textFieldTop: UITextField!
    @IBOutlet weak var textFieldBottom: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    
    //Text Attributes//
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -2.0]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        resetState()
        setTextField(field: textFieldTop, toText: "TOP")
        setTextField(field: textFieldBottom, toText: "BOTTOM")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyBoardNotifications()
    }
    // Do any additional setup after loading the view.
    //outlets//
    
    @IBAction func pickAnImage(_ sender: Any) {
        let input = sender as! UIBarButtonItem
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = input.tag == 1 ? .camera : .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        print("image")
    }
    
    
    
    @IBAction func shareImage(_ sender: Any) {
        let sharedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [sharedImage], applicationActivities: nil)
        controller.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if completed && error == nil {
                self.saveMeme()
            }
        }
        controller.isModalInPresentation = true
        present(controller,animated: true, completion: nil)
    }
    
    //functions//
    
    func setTextField (field: UITextField, toText: String) {
        field.defaultTextAttributes = memeTextAttributes
        field.adjustsFontSizeToFitWidth = true
        field.textAlignment = .center
        field.delegate = self
        field.text = toText
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:       [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print("banana")
            imagePickerView.image = image
        }
        self.dismiss(animated: true, completion: nil)
        shareButton.isEnabled = true
    }
    
    func saveMeme() {
        let meme = Meme(textFieldTop: textFieldTop.text!, textFieldBottom: textFieldBottom.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        //hide toolbars//
        self.topToolBar.isHidden = true
        self.bottomToolBar.isHidden = true
        //render to viewer//
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        // Show toolbar
        self.topToolBar.isHidden = false
        self.bottomToolBar.isHidden = false
        let memeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        return memeImage
    }
    
    func resetState(){
        imagePickerView.image = nil
        textFieldTop.text = "TOP"
        textFieldBottom.text = "BOTTOM"
        shareButton.isEnabled = false
        
    }
    //keyboard setup functions//
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //Erase the default text when editing
        if textField == textFieldTop && textField.text == "TOP" {
            textField.text = ""
            
        } else if textField == textFieldBottom && textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        
    }
    
    
    func getKeyBoardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if textFieldBottom.isEditing {
            view.frame.origin.y = -getKeyBoardHeight(notification)
        }
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func unsubscribeToKeyBoardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillHide(_notification: Notification) {
        view.frame.origin.y = 0
        
    }
    
    @IBAction func discardMeme(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func startOver() {
    if let navigationController = self.navigationController {
        navigationController.popToRootViewController(animated: true)
    
    
    
    
}
}
}
