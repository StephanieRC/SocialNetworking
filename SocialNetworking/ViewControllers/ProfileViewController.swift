//
//  ProfileViewController.swift
//  SocialNetworking
//
//  Created by stephanie Cappello on 11/20/18.
//  Copyright © 2018 stephanie Cappello. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    
    let uid = FirebaseHandler.shared.getCurrentUid()
    let imgpicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgpicker.delegate = self
        FirebaseHandler.shared.fetchTheData(uid: uid){
            (userdata) in
            DispatchQueue.main.async {
                self.phoneField.text = userdata?.phoneNum
                self.emailField.text = userdata?.email
                self.addressField.text = userdata?.address
                self.cityField.text = userdata?.city
            }
        }
        FirebaseHandler.shared.downloadImg(){
            (img, err) in
                DispatchQueue.main.async {
                    self.imgView.image = img
                }
            
        }
    }
    
    @IBAction func imgButton(_ sender: UIButton) {
        imgpicker.allowsEditing = true
        if imgpicker.sourceType == .camera{
            imgpicker.sourceType = .camera
        }else if imgpicker.sourceType == .photoLibrary{
            imgpicker.sourceType = .photoLibrary
        }
        present(imgpicker,animated: true, completion: nil)
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
    
    @IBAction func updateBtn(_ sender: UIButton) {
        FirebaseHandler.shared.updateUserInfo(phone: phoneField.text ?? "", email: emailField.text ?? "", address: addressField.text ?? "", city: cityField.text ?? ""){
            err in
            if err == nil{
                DispatchQueue.main.async {
                    FirebaseHandler.shared.fetchTheData(uid: self.uid){
                        (userdata) in
                        DispatchQueue.main.async {
                            self.phoneField.text = userdata?.phoneNum
                            self.emailField.text = userdata?.email
                            self.addressField.text = userdata?.address
                            self.cityField.text = userdata?.city
                        }
                    }
                }
            }
        }
        FirebaseHandler.shared.uploadImg(image: imgView.image ?? UIImage(named: "bison3")!)
    }
    @IBAction func logoutBtn(_ sender: UIButton) {
        
        
    }
    
}
