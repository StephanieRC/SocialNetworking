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
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: MRKBaseViewController, GIDSignInDelegate, GIDSignInUIDelegate, FBSDKLoginButtonDelegate {

    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    

    @IBOutlet weak var fbloginbtn: FBSDKLoginButton!
    @IBOutlet weak var fblogoutbtn: UIButton!
    
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
                case FacebookAuthProviderID:
                    FBSDKLoginManager().logOut()
                default:
                    break
                }
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
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
    
    @IBAction func fbloginbtn(_ sender: UIButton) {
        fbloginbtn.delegate = self
        fbloginbtn.readPermissions = ["public_profile", "email"]
    }
    @IBAction func fblogoutbtn(_ sender: UIButton) {
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        guard !result.isCancelled, result.grantedPermissions.contains("email") else{
            return
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id,name,birthday,email,first_name,last_name,middle_name,picture.width(4096).height(4096)"])?.start(completionHandler: { (connection, result, error) in
            
            print(result)
            var attributes = Dictionary<String, Any>()
            if let values = result as? Dictionary<String, AnyObject> {
                attributes["facebook_id"] = values["id"]
                attributes["last_name"] = values["last_name"]
                attributes["first_name"] = values["first_name"]
                attributes["email"] = values["email"]
                
                print(attributes)
            }
        })
        
//        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
//            if let error = error {
//                // ...
//                return
//            }
//
//            print(authResult?.user.email)
//            print(authResult?.user.displayName)
//        }
    }
    

}

