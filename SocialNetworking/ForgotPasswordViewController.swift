//
//  ForgotPasswordViewController.swift
//  SocialNetworking
//
//  Created by stephanie Cappello on 11/19/18.
//  Copyright © 2018 stephanie Cappello. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func forgotPwdBtn(_ sender: UIButton) {
        FirebaseHandler().resetPwd(email: emailField.text!)
    }
}
