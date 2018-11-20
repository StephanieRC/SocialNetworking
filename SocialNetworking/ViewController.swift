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

class ViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwdField: UITextField!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = Auth.auth().currentUser{
            //perform segue to tab view controller
        }else{
        }
        
    }

    
    @IBAction func loginBtn(_ sender: UIButton) {
        FirebaseHandler().signIn(email: emailField.text!, passwd: pwdField.text!)
    }
    
}

