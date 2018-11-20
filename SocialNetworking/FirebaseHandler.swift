//
//  FirebaseHandler.swift
//  SocialNetworking
//
//  Created by stephanie Cappello on 11/19/18.
//  Copyright © 2018 stephanie Cappello. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import TWMessageBarManager

//TODO:CREATE USERMODEL

class FirebaseHandler {
    var ref: DatabaseReference! = Database.database().reference().child("USERS")
    var storageref: StorageReference! = Storage.storage().reference()
    
    static let shared = FirebaseHandler()

    private init(){

    }
    
    func updateUserInfo(){
        if let user = Auth.auth().currentUser
        {
            self.ref.child(user.uid).updateChildValues(["name": "imUpdating"]){
                (err, reference) in
                print(err)
            }
        }
    }
    
    func uploadImg(){
        let image = UIImage(named: "bison3")
        let data = image?.pngData()
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        let id = Auth.auth().currentUser?.uid
        let imagename = "UserImages/\(id!)"
        print(imagename)
        storageref = storageref.child(imagename)
        storageref.putData(data!, metadata: metaData){
            (metaDataS, err) in
            print("upload pic")
        }
    }
    
    func downloadImg(){
        let id = Auth.auth().currentUser?.uid
        let imagename = "UserImages/\(id!)"
        print("id: \(id)")
        storageref.child(imagename).getMetadata{
            (meta, err) in
            print(meta)
        }
        storageref.getData(maxSize: 1*600*600*600){
            (data, err) in
            print(err)
            let img = UIImage(data: data!)
        }
    }
    
    func resetPwd(email: String){
        Auth.auth().sendPasswordReset(withEmail: email){
            (err) in
            if err == nil{
                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Success", description: "Email sent to \(email)", type: .success)
            }else{
                TWMessageBarManager.sharedInstance().showMessage(withTitle: "ERR", description: err?.localizedDescription, type: .error)
            }
        }
    }
    
    func signOut(){
        do{
            try Auth.auth().signOut()
        }catch{
            print("err")
        }
    }
    
    func signIn(email:String, passwd:String){
        Auth.auth().signIn(withEmail: email, password: passwd){
            (result, err) in
            if err == nil{
                guard let user = result?.user else {return}
                print(user.email)
                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Success", description: "Sucessfully logged in", type: .success)
            }else
            {
                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Error", description: err?.localizedDescription, type: .error)
            }
        }
    }
    
    func signUp(email: String, pwd: String, name: String, birthdate: String, address: String){
        Auth.auth().createUser(withEmail: email, password: pwd)
        {
            (result, err) in
            if err == nil{
                guard let user = result?.user else {return}
                self.ref.child(user.uid).setValue(["Name": name, "birthdate": birthdate, "address": address],
                                                  withCompletionBlock:{
                                                    (err, self) in
                                                    if let err = err {
                                                        print("Data could not be saved: \(err).")
                                                    } else {
                                                        
                                                        print("Data saved successfully!")
                                                    }
                                                    
                })
                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Success", description: "Sucessfully created new user", type: .success)
                self.uploadImg()
            }else
            {
                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Error", description: err?.localizedDescription, type: .error)
            }
        }
    }
    
    func fetchTheData(){
        let user = Auth.auth().currentUser
        ref.child(user?.uid ?? "1").observeSingleEvent(of: .value)
        {(Snapchat) in
            if let dict = Snapchat.value as? [String: Any]{
                print(dict)
            }
            
        }
    }
    
    func fetchUsers()->[String]{
        var keys : [String] = []
        ref?.observeSingleEvent(of: .value){
            (snapshot) in
            if let user = snapshot.value as? [String: Any]{
                for u in user{
                    keys.append(u.key)
                }
            }
        }
        return keys
    }
}
