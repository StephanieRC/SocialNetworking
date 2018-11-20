//
//  WelcomeViewController.swift
//  SocialNetworking
//
//  Created by stephanie Cappello on 11/19/18.
//  Copyright © 2018 stephanie Cappello. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class WelcomeViewController: UIViewController {

    @IBOutlet weak var welcomeLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeLbl.text = Auth.auth().currentUser?.email
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signOutBtn(_ sender: UIButton) {
        signOut()
    }
    
    func signOut(){
        try! Auth.auth().signOut()
    }

}
