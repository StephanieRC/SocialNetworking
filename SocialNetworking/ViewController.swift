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
import GoogleSignIn

class ViewController: MRKBaseViewController, GIDSignInDelegate, GIDSignInUIDelegate {

    
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

    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @IBAction func googleLogin(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func logoutbtn(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signOut()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            // ...
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)

        if let providerInfo = Auth.auth().currentUser?.providerData {
            for userInfo in providerInfo {
                print(userInfo.providerID)
                switch userInfo.providerID {
                case GoogleAuthProviderID:
                    GIDSignIn.sharedInstance().signOut()
                default:
                    break
                }
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
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

