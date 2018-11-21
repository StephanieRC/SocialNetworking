//
//  ViewController.swift
//  SocialNetworking
//
//  Created by stephanie Cappello on 11/16/18.
//  Copyright © 2018 stephanie Cappello. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ViewController: MRKBaseViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwdField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        if let user = Auth.auth().currentUser{
            //perform segue to tab view controller
            performSegue(withIdentifier: "loginSegue", sender: true)
        }else{
        }
        
    }

    @IBAction func unwindToContainerVC(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func loginBtn(_ sender: UIButton) {
        FirebaseHandler.shared.signIn(email: emailField.text!, passwd: pwdField.text!){
            (err) in
            if err == nil{
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "loginSegue", sender: true)
                }
            }
        }
    }
    
}

