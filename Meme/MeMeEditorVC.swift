//
//  MeMeEditorVC.swift
//  Meme2.0
//
//  Created by Adrian Borcea on 06/09/2016.
//  Copyright © 2016 Adrian Borcea. All rights reserved.
//

import UIKit


class MeMeEditorVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {

    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var txtTop: UITextField!
    @IBOutlet weak var btnShare: UIBarButtonItem!
    @IBOutlet weak var txtBottom: UITextField!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnAlbum: UIBarButtonItem!
    @IBOutlet weak var btnCamera: UIBarButtonItem!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.black,
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName :-3.0,
            NSParagraphStyleAttributeName:style
        ] as [String : Any]
        
        txtTop.defaultTextAttributes=memeTextAttributes
        txtBottom.defaultTextAttributes=memeTextAttributes
        btnShare.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
         btnCamera.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        
        addNotificationForKeyboard()
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        removeKeyboardNotifications()
        super.viewWillDisappear(animated)
    }

    func addNotificationForKeyboard() -> Void {
        
        NotificationCenter.default.addObserver(self, selector: #selector(MeMeEditorVC.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MeMeEditorVC.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func removeKeyboardNotifications() -> Void {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func keyboardWillShow(_ notification: Notification) -> Void {
        
    
        if txtBottom.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
        
    }
    func keyboardWillHide(_ notification: Notification) -> Void {
        
        if txtBottom.isFirstResponder {
            view.frame.origin.y = 0
        }
        
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        
        let userinfo = (notification as NSNotification).userInfo
        let keyboardSize = userinfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }

    @IBAction func pickImageFromPhoto(_ sender: AnyObject) {
        
        pickImage(false)
    }
    
    @IBAction func pickImageFromCamera(_ sender: AnyObject) {
        
        pickImage(true)
    }
    
    func pickImage(_ isCamera: Bool) -> Void {
        
        let picker=UIImagePickerController()
        picker.delegate = self
        
        if isCamera {
            
            picker.sourceType = UIImagePickerControllerSourceType.camera
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
           if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imgView.image = image
            btnShare.isEnabled = true
            dismiss(animated: true, completion: nil)
           }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let defaultText:String
        
        if textField == txtTop {
            
            defaultText="TOP"
        }else{
            
            defaultText="BOTTOM"
        }
        
        if let text = textField.text , text == defaultText {
            
            textField.text=""
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func save() {
        
        let memedImage = generateMemedImage()
        let meme = MeMe(topText: txtTop.text! , bottomText:txtBottom.text!, originalImage: imgView.image!, memedImage: memedImage)
        
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
        
        dismiss(animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage
    {
        
        bottomToolBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame,
                                     afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        
        bottomToolBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
        
        return memedImage
    }

    @IBAction func shareBtnPressed(_ sender: AnyObject) {
        
        let memedImage = generateMemedImage()
        
        let objectsToShare = [memedImage]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        activityVC.completionWithItemsHandler = {
            (activity, success, items, error) in
           
            if success{
                self.save()
            }
            
        }
        activityVC.popoverPresentationController?.sourceView = sender as? UIButton
        present(activityVC, animated: true, completion: nil)
    }
    @IBAction func cancelBtnPressed(_ sender: AnyObject) {
        
         dismiss(animated: true, completion: nil)
    }
}

