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

typealias completionHandler = ([User]?) ->()
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
    
    func signIn(email:String, passwd:String, completion: @escaping (Error?) ->()){
        Auth.auth().signIn(withEmail: email, password: passwd){
            (result, err) in
            if err == nil{
                guard let user = result?.user else {return}
                //fetchdata
                completion(nil)
                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Success", description: "Sucessfully logged in", type: .success)
            }else
            {
                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Error", description: err?.localizedDescription, type: .error)
                completion(err!)
            }
        }
    }
    
    func signUp(email: String, pwd: String, name: String, birthdate: String, address: String, displayName:String, phoneNum: String, language:String, city:String, state:String, zipcode:String, country:String, completion: @escaping (Error?) ->()){
        Auth.auth().createUser(withEmail: email, password: pwd)
        {
            (result, err) in
            if err == nil{
                guard let user = result?.user else {return}
                self.ref.child(user.uid).setValue(["name": name, "displayName": displayName, "birthdate": birthdate, "address": address, "city": city, "state": state, "country": country, "zipcode": zipcode, "language": language, "phoneNum": phoneNum],
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
                completion(nil)
            }else
            {
                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Error", description: err?.localizedDescription, type: .error)
                completion(err)
            }
        }
    }
    
    func fetchTheData(completion: @escaping (User?) ->()){
        let user = Auth.auth().currentUser
        ref.child(user?.uid ?? "1").observeSingleEvent(of: .value)
        {(Snapchat) in
            if let dict = Snapchat.value as? [String: Any]{
                let usermodel: User = User.init(id: user?.uid as String!, displayName: dict["displayName"] as! String, email: dict["email"] as! String, name:dict["name"] as! String, phoneNum: dict["phoneNum"] as! String, language: dict["language"] as! String, birthdate: dict["birthdate"] as! String, address: dict["address"] as! String, city: dict["city"] as! String, state: dict["state"] as! String, country: dict["country"] as! String, zipcode: dict["zipcode"] as! String)
                completion(usermodel)
            }else{
                completion(nil)
            }
        }
    }
    
    //closures
    func fetchUsers(completion: @escaping completionHandler){
        var userArr : [User] = []
        ref?.observeSingleEvent(of: .value){
            (snapshot) in
            if let user = snapshot.value as? [String: [String: Any]]{
                for u in user{
                    let usermodel: User = User.init(id: u.key as? String ?? "", displayName: u.value["displayName"] as? String ?? "", email: u.value["email"] as? String ?? "", name: u.value["name"] as? String ?? "", phoneNum: u.value["phoneNum"] as? String ?? "", language: u.value["language"] as? String ?? "", birthdate: u.value["birthdate"] as? String ?? "", address: u.value["address"] as? String ?? "", city: u.value["city"] as? String ?? "", state: u.value["state"] as? String ?? "", country: u.value["country"] as? String ?? "", zipcode: u.value["zipcode"] as? String ?? "")
                    userArr.append(usermodel)
                }
                completion(userArr)
            }else{
                completion(nil)
            }
        }
    }
}
