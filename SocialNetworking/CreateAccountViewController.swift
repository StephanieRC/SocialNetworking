//
//  CreateAccountViewController.swift
//  SocialNetworking
//
//  Created by stephanie Cappello on 11/20/18.
//  Copyright © 2018 stephanie Cappello. All rights reserved.
//

import UIKit

class CreateAccountViewController: MRKBaseViewController {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwdField: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var birthdateField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func selectImg(_ sender: UIButton) {
    }
    
    @IBAction func signUpBtn(_ sender: UIButton) {
        if !(nameField.text?.isEmpty)! && !(emailField.text?.isEmpty)! && !(pwdField.text?.isEmpty)! && !(confirmPassword.text?.isEmpty)! && !(birthdateField.text?.isEmpty)! && !(addressField.text?.isEmpty)!{
            if pwdField.text == confirmPassword.text{
                FirebaseHandler.shared.signUp(email: emailField.text!, pwd: pwdField.text!, name: nameField.text!, birthdate: birthdateField.text!, address: addressField.text!)
                navigationController?.popViewController(animated: true)
            }
        }
    }
}
