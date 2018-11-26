//
//  ProfileViewController.swift
//  SocialNetworking
//
//  Created by stephanie Cappello on 11/20/18.
//  Copyright © 2018 stephanie Cappello. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseHandler.shared.fetchTheData(){
            (userdata) in
            DispatchQueue.main.async {
                self.phoneField.text = userdata?.phoneNum
                self.emailField.text = userdata?.email
                self.addressField.text = userdata?.address
                self.cityField.text = userdata?.city
            }
            
        }
    }
    
    @IBAction func imgButton(_ sender: UIButton) {
    }
    
    @IBAction func updateBtn(_ sender: UIButton) {
    }
    
    @IBAction func resetPwdBtn(_ sender: UIButton) {
        FirebaseHandler.shared.resetPwd(email: Auth.auth().currentUser?.email ?? "")
    }
    
    @IBAction func logoutBtn(_ sender: UIButton) {
        
        do{
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "unwindSegue", sender: self)
        }catch{
            
        }
    }
    
}
