//
//  SettingsViewController.swift
//  SocialNetworking
//
//  Created by stephanie Cappello on 11/26/18.
//  Copyright © 2018 stephanie Cappello. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func resetPwdBtn(_ sender: UIButton) {
        FirebaseHandler.shared.resetPwd(email: Auth.auth().currentUser?.email ?? "")
    }
    
    @IBAction func logoutBtn(_ sender: UIButton) {
        FirebaseHandler.shared.signOut()
        let mainStoreBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = mainStoreBoard.instantiateViewController(withIdentifier: "SignInViewController")
        UIApplication.shared.keyWindow?.rootViewController = controller
    }
}
