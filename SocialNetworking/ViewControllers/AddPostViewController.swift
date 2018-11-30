//
//  AddPostViewController.swift
//  SocialNetworking
//
//  Created by stephanie Cappello on 11/29/18.
//  Copyright © 2018 stephanie Cappello. All rights reserved.
//

import UIKit
import TWMessageBarManager
import SVProgressHUD

class AddPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    let imgPicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgPicker.delegate = self
    }
    
    @IBAction func cancelBtn(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "unwindSegue", sender: self)
    }
    
    @IBAction func addBarBtn(_ sender: UIBarButtonItem) {
        SVProgressHUD.show()
        FirebaseHandler.shared.addPost(img: imgView.image!, description: descriptionTextView.text) { (err) in
            DispatchQueue.main.async{
                SVProgressHUD.dismiss()
            }
            if err == nil{
                self.dismiss(animated: true)
            }else{
                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Error", description: err?.localizedDescription, type: .error)
            }
        }
    }
    
    
    @IBAction func imgBtn(_ sender: UIButton) {
        imgPicker.allowsEditing = true
        if imgPicker.sourceType == .camera{
            imgPicker.sourceType = .camera
        }else if imgPicker.sourceType == .photoLibrary{
            imgPicker.sourceType = .photoLibrary
        }
        present(imgPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imgView.image = img
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
