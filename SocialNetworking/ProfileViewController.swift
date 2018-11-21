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
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var birthdateField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func imgButton(_ sender: UIButton) {
    }
    
    @IBAction func updateBtn(_ sender: UIButton) {
        let crash = ["fds","fdsa"]
        print(crash[3])
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
