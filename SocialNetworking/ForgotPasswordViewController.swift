//
//  ForgotPasswordViewController.swift
//  SocialNetworking
//
//  Created by stephanie Cappello on 11/19/18.
//  Copyright © 2018 stephanie Cappello. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: MRKBaseViewController {

    @IBOutlet weak var emailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func forgotPwdBtn(_ sender: UIButton) {
        FirebaseHandler.shared.resetPwd(email: emailField.text!)
        navigationController?.popViewController(animated: true)
    }
}
