//
//  FirebaseHandler.swift
//  SocialNetworking
//
//  Created by stephanie Cappello on 11/19/18.
//  Copyright © 2018 stephanie Cappello. All rights reserved.
//

import Foundation
import FirebaseDatabase
import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import TWMessageBarManager
import FBSDKCoreKit
import FBSDKLoginKit

typealias completionHandler = ([User]?) ->()
//TODO:CREATE USERMODEL

class FirebaseHandler {
    
    var ref: DatabaseReference! = Database.database().reference().child("USERS")
    var storageref: StorageReference! = Storage.storage().reference()
    
    static let shared = FirebaseHandler()
    
    private init(){
        
    }
    
    func getCurrentUid() -> String {
        return Auth.auth().currentUser?.uid ?? ""
    }
    
    func updateUserInfo(phone:String, email: String, address: String, city: String, completion: @escaping (Error?) ->()){
        if let user = Auth.auth().currentUser
        {
            self.ref.child(user.uid).updateChildValues(["email": email, "phoneNum": phone, "address": address, "city": city]){
                (err, reference) in
                if err == nil{
                    completion(nil)
                }else{
                    completion(err)
                }
            }
        }
    }
    
    func uploadImg(image: UIImage){
            let data = image.jpeg(UIImage.JPEGQuality.lowest)
            let metaData = StorageMetadata()
            metaData.contentType = "image/png"
            let id = Auth.auth().currentUser?.uid
            let imagename = "UserImages/\(id!)"
            storageref.child(imagename).putData(data!, metadata: metaData){
                (metaDataS, err) in
                print("upload pic")
            }
        
    }
    
    func downloadImg(completion: @escaping (UIImage?, Error?)-> ()){
        let id = Auth.auth().currentUser?.uid
        let imagename = "UserImages/\(id!)"
        storageref.child(imagename).getData(maxSize: 1*600*600*600){
            (data, err) in
            if err == nil{
                let img = UIImage(data: data!)
                completion(img, nil)
            }else{
                let img = UIImage(named: "anon_default")
                completion(img, err)
            }
            
        }
    }
    
    func downloadAnyUserImg(uid: String, completion: @escaping (UIImage?, Error?)-> ()){
        let id = uid
        let imagename = "UserImages/\(id)"
        storageref.child(imagename).getData(maxSize: 1*1200*1200){
            (data, err) in
            if err == nil{
                let img = UIImage(data: data!)
                completion(img, nil)
            }else{
                let img = UIImage(named: "anon_default")
                completion(img, err)
            }
            
        }
    }
    
    func addFriend(friendId : String, userid: String, completion : @escaping (String) -> ()) {
        ref.child(userid).child("friends").updateChildValues([friendId: "friendId"]) { (err, dbref) in
            if err == nil{
                completion("You have a friend!")
            }else{
                completion("no friend for you")
            }
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
    
    func signUp(email: String, pwd: String, name: String, birthdate: String, address: String, displayName:String, phoneNum: String, language:String, city:String, state:String, zipcode:String, country:String, img: UIImage, completion: @escaping (Error?) ->()){
        Auth.auth().createUser(withEmail: email, password: pwd)
        {
            (result, err) in
            if err == nil{
                guard let user = result?.user else {return}
                self.ref.child(user.uid).setValue(["name": name, "displayName": displayName, "email": email, "birthdate": birthdate, "address": address, "city": city, "state": state, "country": country, "zipcode": zipcode, "language": language, "phoneNum": phoneNum],
                                                  withCompletionBlock:{
                                                    (err, self) in
                                                    if let err = err {
                                                        print("Data could not be saved: \(err).")
                                                    } else {
                                                        
                                                        print("Data saved successfully!")
                                                    }
                                                    
                })
                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Success", description: "Sucessfully created new user", type: .success)
                self.uploadImg(image: img)
                completion(nil)
            }else
            {
                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Error", description: err?.localizedDescription, type: .error)
                completion(err)
            }
        }
    }
    
    func fetchTheData(uid: String, completion: @escaping (User?) ->()){
        ref.child(uid).observeSingleEvent(of: .value)
        {(Snapchat) in
            if let dict = Snapchat.value as? [String: Any]{
                let usermodel: User = User.init(id: uid, displayName: dict["displayName"] as? String ?? "", email: dict["email"] as? String ?? "", name:dict["name"] as? String ?? "", phoneNum: dict["phoneNum"] as? String ?? "", language: dict["language"] as? String ?? "", birthdate: dict["birthdate"] as? String ?? "", address: dict["address"] as? String ?? "", city: dict["city"] as? String ?? "", state: dict["state"] as? String ?? "", country: dict["country"] as? String ?? "", zipcode: dict["zipcode"] as? String ?? "", img: nil)
                completion(usermodel)
            }else{
                completion(nil)
            }
        }
    }
    //
    func retrieveFriendList(completion: @escaping ([User]?)->()){
        var friendArr: [User] = []
        let dispatchgroup = DispatchGroup()
        ref.child(getCurrentUid()).child("friends").observeSingleEvent(of: .value, with: { (snapshot) in
            if let friends = snapshot.value as? [String: String]{
                for friend in friends{
                    dispatchgroup.enter()
                    self.ref.child(friend.key).observeSingleEvent(of: .value, with: { (singleFriendSnapShot) in
                        guard let singleFriend = singleFriendSnapShot.value as? Dictionary<String, Any> else{
                            return
                        }
                        let usermodel: User = User.init(id: friend.key, displayName: singleFriend["displayName"] as? String ?? "", email: singleFriend["email"] as? String ?? "", name: singleFriend["name"] as? String ?? "", phoneNum: singleFriend["phoneNum"] as? String ?? "", language: singleFriend["language"] as? String ?? "", birthdate: singleFriend["birthdate"] as? String ?? "", address: singleFriend["address"] as? String ?? "", city: singleFriend["city"] as? String ?? "", state: singleFriend["state"] as? String ?? "", country: singleFriend["country"] as? String ?? "", zipcode: singleFriend["zipcode"] as? String ?? "", img: nil)
                        self.downloadAnyUserImg(uid: usermodel.id, completion: { (img, err) in
                            usermodel.img = img
                            friendArr.append(usermodel)
                            dispatchgroup.leave()
                        })
                    })
                }
                dispatchgroup.notify(queue: .main){
                    completion(friendArr)
                }
            }else{
                completion(nil)
            }
        })
    }
    
    //closures
    func fetchUsers(completion: @escaping completionHandler){
        var userArr : [User] = []
        let fetchUserGroup = DispatchGroup()
        let fetchUserComponentsGroup = DispatchGroup()
        fetchUserGroup.enter()
        ref?.observeSingleEvent(of: .value){
            (snapshot) in
            if let user = snapshot.value as? [String: [String: Any]]{
                for u in user{
                    let usermodel: User = User.init(id: u.key, displayName: u.value["displayName"] as? String ?? "", email: u.value["email"] as? String ?? "", name: u.value["name"] as? String ?? "", phoneNum: u.value["phoneNum"] as? String ?? "", language: u.value["language"] as? String ?? "", birthdate: u.value["birthdate"] as? String ?? "", address: u.value["address"] as? String ?? "", city: u.value["city"] as? String ?? "", state: u.value["state"] as? String ?? "", country: u.value["country"] as? String ?? "", zipcode: u.value["zipcode"] as? String ?? "", img: nil)
                    fetchUserComponentsGroup.enter()
                    self.downloadAnyUserImg(uid: u.key, completion: { (img, err) in
                        usermodel.img = img
                        fetchUserComponentsGroup.leave()
                        if usermodel.id != self.getCurrentUid(){
                            userArr.append(usermodel)
                        }
                    })
                }
                
                fetchUserComponentsGroup.notify(queue: .main) {
                    fetchUserGroup.leave()
                }
                
                fetchUserGroup.notify(queue: .main) {
                    // now the currentUser should be properly configured
                    completion(userArr)
                }
            }else{
                completion(nil)
            }
        }
    }
}
