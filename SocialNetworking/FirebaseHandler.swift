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
    
    var userRef: DatabaseReference! = Database.database().reference().child("USERS")
    var postRef: DatabaseReference! = Database.database().reference().child("POSTS")
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
            self.userRef.child(user.uid).updateChildValues(["email": email, "phoneNum": phone, "address": address, "city": city]){
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
        userRef.child(userid).child("friends").updateChildValues([friendId: "friendId"]) { (err, dbref) in
            if err == nil{
                completion("You have a friend!")
            }else{
                completion("no friend for you")
            }
        }
    }
    
    func addCoor(lat : String, lon: String, completion : @escaping (Error?) -> ()) {
        userRef.child(getCurrentUid()).child("coordinate").updateChildValues(["lat": lat, "lon": lon]) { (err, dbref) in
            if err == nil{
                completion(nil)
            }else{
                completion(err)
            }
        }
    }
    
    func removeFriend(friendId : String, userid: String, completion : @escaping (String) -> ()) {
        userRef.child(userid).child("friends").child(friendId).removeValue { (err, dbref) in
            if err == nil{
                completion("Friend is no longer")
            }else{
                completion("U are still friends")
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
    
    func signUp(email: String, pwd: String, name: String, birthdate: String, address: String, displayName:String, phoneNum: String, language:String, city:String, state:String, zipcode:String, country:String, lat: String, lon: String, img: UIImage, completion: @escaping (Error?) ->()){
        let dispatchgroup = DispatchGroup()
        Auth.auth().createUser(withEmail: email, password: pwd)
        {
            (result, err) in
            if err == nil{
                dispatchgroup.enter()
                guard let user = result?.user else {return}
                self.userRef.child(user.uid).setValue(["name": name, "displayName": displayName, "email": email, "birthdate": birthdate, "address": address, "city": city, "state": state, "country": country, "zipcode": zipcode, "language": language, "phoneNum": phoneNum],
                                                      withCompletionBlock:{
                                                        (err, self) in
                                                        if let err = err {
                                                            print("Data could not be saved: \(err).")
                                                        } else {
                                                            print("Data saved successfully!")
                                                        }
                                                        
                })
                self.uploadImg(image: img)
                self.addCoor(lat: lat, lon: lon, completion: { (err) in
                    if err == nil{
                        dispatchgroup.leave()
                    }else{
                        print(err?.localizedDescription)
                    }
                })
                //                dispatchgroup.leave()
                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Success", description: "Sucessfully created new user", type: .success)
                //                completion(nil)
            }else
            {
                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Error", description: err?.localizedDescription, type: .error)
                completion(err)
            }
            dispatchgroup.notify(queue: .main){
                completion(nil)
            }
        }
    }
    
    func fetchTheData(uid: String, completion: @escaping (User?) ->()){
        userRef.child(uid).observeSingleEvent(of: .value)
        {(Snapchat) in
            if let dict = Snapchat.value as? [String: Any]{
                let coor = dict["coordinate"] as? [String: String]
                let postArr = dict["posts"] as? [String: Any]
                let usermodel: User = User.init(id: uid,
                                                displayName: dict["displayName"] as? String ?? "",
                                                email: dict["email"] as? String ?? "",
                                                name:dict["name"] as? String ?? "",
                                                phoneNum: dict["phoneNum"] as? String ?? "",
                                                language: dict["language"] as? String ?? "",
                                                birthdate: dict["birthdate"] as? String ?? "",
                                                address: dict["address"] as? String ?? "",
                                                city: dict["city"] as? String ?? "",
                                                state: dict["state"] as? String ?? "",
                                                country: dict["country"] as? String ?? "",
                                                zipcode: dict["zipcode"] as? String ?? "",
                                                lat: coor?["lat"] ?? "",
                                                lon: coor?["lon"] ?? "",
                                                postCount: postArr?.count ?? 100,
                                                img: nil)
                completion(usermodel)
            }else{
                completion(nil)
            }
        }
    }
    
    //MARK: Alok's implementation DispatchGroup()
    func retrieveFriendList(completion: @escaping ([User]?)->()){
        var friendArr: [User] = []
        let dispatchgroup = DispatchGroup()
        userRef.child(getCurrentUid()).child("friends").observeSingleEvent(of: .value, with: { (snapshot) in
            if let friends = snapshot.value as? [String: String]{
                for friend in friends{
                    dispatchgroup.enter()
                    self.userRef.child(friend.key).observeSingleEvent(of: .value, with: { (singleFriendSnapShot) in
                        guard let singleFriend = singleFriendSnapShot.value as? Dictionary<String, Any> else{
                            return
                        }
                        let coor = singleFriend["coordinate"] as? [String: String]
                        let postArr = singleFriend["posts"] as? [String: Any]
                        let usermodel: User = User.init(id: friend.key,
                                                        displayName: singleFriend["displayName"] as? String ?? "",
                                                        email: singleFriend["email"] as? String ?? "",
                                                        name: singleFriend["name"] as? String ?? "",
                                                        phoneNum: singleFriend["phoneNum"] as? String ?? "",
                                                        language: singleFriend["language"] as? String ?? "",
                                                        birthdate: singleFriend["birthdate"] as? String ?? "",
                                                        address: singleFriend["address"] as? String ?? "",
                                                        city: singleFriend["city"] as? String ?? "",
                                                        state: singleFriend["state"] as? String ?? "",
                                                        country: singleFriend["country"] as? String ?? "",
                                                        zipcode: singleFriend["zipcode"] as? String ?? "",
                                                        lat: coor?["lat"] ?? "",
                                                        lon: coor?["lon"] ?? "",
                                                        postCount: postArr?.count ?? 100,
                                                        img: nil)
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
    
    func retrieveFriendUID(completion: @escaping ([String])->()) {
        var friendUidArr: [String] = []
        userRef.child(getCurrentUid()).child("friends").observeSingleEvent(of: .value) { (ds) in
            if let friendsuids = ds.value as? [String: String]{
                for frienduid in friendsuids{
                    friendUidArr.append(frienduid.key)
                }
                completion(friendUidArr)
            }else{
                completion([])
            }
        }
    }
    
    //closures
    //MARK: Lokesh's implementation DispatchGroup()
    func fetchUsers(completion: @escaping ([(user: User, friend: Bool)]?) ->()){
        retrieveFriendUID { (friendslist) in
            var userArr : [(User, Bool)] = []
            let fetchUserGroup = DispatchGroup()
            let fetchUserComponentsGroup = DispatchGroup()
            fetchUserGroup.enter()
            self.userRef?.observeSingleEvent(of: .value){
                (snapshot) in
                if let user = snapshot.value as? [String: [String: Any]]{
                    for u in user{
                        let coor = u.value["coordinate"] as? [String: String]
                        let postArr = u.value["posts"] as? [String: Any]
                        let usermodel: User = User.init(id: u.key,
                                                        displayName: u.value["displayName"] as? String ?? "",
                                                        email: u.value["email"] as? String ?? "",
                                                        name: u.value["name"] as? String ?? "",
                                                        phoneNum: u.value["phoneNum"] as? String ?? "",
                                                        language: u.value["language"] as? String ?? "",
                                                        birthdate: u.value["birthdate"] as? String ?? "",
                                                        address: u.value["address"] as? String ?? "",
                                                        city: u.value["city"] as? String ?? "",
                                                        state: u.value["state"] as? String ?? "",
                                                        country: u.value["country"] as? String ?? "",
                                                        zipcode: u.value["zipcode"] as? String ?? "",
                                                        lat: coor?["lat"] ?? "",
                                                        lon: coor?["lon"] ?? "",
                                                        postCount: postArr?.count ?? 100,
                                                        img: nil)
                        let friend: Bool = friendslist.contains(u.key) ? true: false
                        fetchUserComponentsGroup.enter()
                        self.downloadAnyUserImg(uid: u.key, completion: { (img, err) in
                            usermodel.img = img
                            fetchUserComponentsGroup.leave()
                            if usermodel.id != self.getCurrentUid(){
                                userArr.append((usermodel, friend))
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
    
    func addPost(img: UIImage, description:String, completion: @escaping (Error?)->()){
        let postKey = postRef.childByAutoId().key
        let dg = DispatchGroup()
        postRef.child(postKey!).setValue(["description": description,
                                          "timestamp": NSDate().timeIntervalSince1970,
                                          "userId": getCurrentUid()],
                                         withCompletionBlock:{
                                            (err, selfRef) in
                                            if err == nil {
                                                dg.enter()
                                                self.addPostStorage(img: img, postKey: postKey!, completion: { (err) in
                                                    if err == nil{
                                                        dg.leave()
                                                    }else{
                                                        completion(err)
                                                    }
                                                })
                                                dg.enter()
                                                self.addPostRefCurrentUser(postKey: postKey ?? "", completion: { (err) in
                                                    if err == nil{
                                                        dg.leave()
                                                    }else{
                                                        completion(err)
                                                    }
                                                })
                                                dg.notify(queue: .main){
                                                    print("Print hopefully once!")
                                                    completion(nil)
                                                }
                                            } else {
                                                completion(err)
                                                print("Data could not be saved: \(err).")
                                            }
                                            
        })
        
    }
    
    func addPostRefCurrentUser(postKey:String, completion: @escaping (Error?)->()){
        userRef.child(getCurrentUid()).child("posts").updateChildValues([postKey: "postKey"]) { (err, dbref) in
            completion(err)
        }
    }
    
    func addPostStorage(img: UIImage, postKey: String, completion: @escaping (Error?)->()){
        let data = img.jpeg(UIImage.JPEGQuality.lowest)
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        let imagename = "Posts/\(postKey)"
        storageref.child(imagename).putData(data!, metadata: metaData) { (storMetaData, err) in
            if err == nil{
                completion(nil)
            }else{
                completion(err)
            }
        }
    }
    
    func retrievePostDetails(completion: @escaping ([PostDetail])->()){
        let dg = DispatchGroup()
        let postDg = DispatchGroup()
        var postDetailArr: [PostDetail] = []
        retrievePostIds { (postIds) in
            for postId in postIds{
                postDg.enter()
                self.postRef.child(postId).observeSingleEvent(of: .value, with: { (ds) in
                    if let dsPost = ds.value as? [String: Any]{
                        let likeStr = dsPost["likeBy"] as? [String: String] ?? [:]
                        var likebyArr: [String] = []
                        for like in likeStr{
                            likebyArr.append(like.key)
                        }
                        var post: PostDetail = PostDetail(description: dsPost["description"] as? String ?? "",
                                                          imageRef: ds.key,
                                                          like: nil,
                                                          timestamp: dsPost["timestamp"] as? Double ?? 0.0,
                                                          userId: dsPost["userId"] as? String ?? "",
                                                          postImage: nil,
                                                          postUserImage: nil,
                                                          name: nil,
                                                          isLike: false,
                                                          likeby: likebyArr,
                                                          commentby: dsPost["commentBy"] as? [String: String] ?? [:])
                        post.like = post.likeby.count
                        post.isLike = post.likeby.contains(self.getCurrentUid())
                        dg.enter()
                        self.retrieveDisplayNameUser(userId: post.userId, completion: { (displayName) in
                            post.name = displayName
                            dg.leave()
                        })
                        dg.enter()
                        self.downloadAnyUserImg(uid: post.userId, completion: { (img, err) in
                            if err == nil {
                                post.postUserImage = img
                            }
                            dg.leave()
                        })
                        dg.enter()
                        self.retrievePostPhoto(postKey: post.imageRef, completion: { (img, err) in
                            if err == nil {
                                post.postImage = img
                            }
                            dg.leave()
                        })
                        dg.notify(queue: .main){
                            postDetailArr.append(post)
                            postDg.leave()
                        }
                    }
                })
            }
            postDg.notify(queue: .main){
                postDetailArr.sort(){$0.timestamp > $1.timestamp}
                completion(postDetailArr)
            }
        }
    }
    
    func retrievePostsForUser(userid:String, completion: @escaping ([PostDetail])->()){
        let dg = DispatchGroup()
        let postDg = DispatchGroup()
        var postDetailArr: [PostDetail] = []
        userRef.child(userid).child("posts").observeSingleEvent(of: .value) { (datasnapshot) in
            let postIds = datasnapshot.value as? [String: Any] ?? [:]
            for postId in postIds{
                postDg.enter()
                self.postRef.child(postId.key).observeSingleEvent(of: .value, with: { (ds) in
                    if let dsPost = ds.value as? [String: Any]{
                        var post: PostDetail = PostDetail(description: dsPost["description"] as? String ?? "",
                                                          imageRef: ds.key,
                                                          like: nil,
                                                          timestamp: dsPost["timestamp"] as? Double ?? 0.0,
                                                          userId: dsPost["userId"] as? String ?? "",
                                                          postImage: nil,
                                                          postUserImage: nil,
                                                          name: nil,
                                                          isLike: false,
                                                          likeby: dsPost["likeBy"] as? [String] ?? [],
                                                          commentby: dsPost["commentBy"] as? [String: String] ?? [:])
                        post.like = post.likeby.count
                        post.isLike = post.likeby.contains(self.getCurrentUid())
                        dg.enter()
                        self.retrieveDisplayNameUser(userId: post.userId, completion: { (displayName) in
                            post.name = displayName
                            dg.leave()
                        })
                        dg.enter()
                        self.downloadAnyUserImg(uid: post.userId, completion: { (img, err) in
                            if err == nil {
                                post.postUserImage = img
                            }
                            dg.leave()
                        })
                        dg.enter()
                        self.retrievePostPhoto(postKey: post.imageRef, completion: { (img, err) in
                            if err == nil {
                                post.postImage = img
                            }
                            dg.leave()
                        })
                        dg.notify(queue: .main){
                            postDetailArr.append(post)
                            postDg.leave()
                        }
                    }
                })
            }
            postDg.notify(queue: .main){
                postDetailArr.sort(){$0.timestamp > $1.timestamp}
                completion(postDetailArr)
            }
        }
    }
    
    func retrieveDisplayNameUser(userId: String, completion:@escaping (String)->()){
        userRef.child(userId).child("displayName").observeSingleEvent(of: .value) { (ds) in
            completion(ds.value as? String ?? "")
        }
    }
    
    func retrievePostPhoto(postKey: String, completion: @escaping (UIImage?, Error?)->()){
        storageref.child("Posts").child(postKey).getData(maxSize: 600*600*600) { (data, err) in
            if err == nil && data != nil{
                let img = UIImage(data: data!)
                completion(img, nil)
            }else{
                completion(nil, err)
            }
        }
    }
    
    func retrievePostIds(completion: @escaping ([String])->()){
        var postIds: [String] = []
        let dg = DispatchGroup()
        userRef.observeSingleEvent(of: .value) { (friendUidArr) in
            let userUids = friendUidArr.value as? [String: [String: Any]]
            for userUid in userUids ?? [:]{
                dg.enter()
                self.userRef.child(userUid.key).child("posts").observeSingleEvent(of: .value, with: { (ds) in
                    if let posts = ds.value as? [String: String]{
                        for post in posts ?? [:]{
                            postIds.append(post.key)
                        }
                    }
                    dg.leave()
                })
            }
            dg.notify(queue: .main, execute: {
                completion(postIds)
            })
        }
    }
    
    func setPostLike(postId:String, uid:String, currentlyLiked: Bool, completion: @escaping (Error?)->()){
        if currentlyLiked == true{
            postRef.child(postId).child("likeBy").child(uid).removeValue { (err, db) in
                completion(err)
            }
        }else{
            postRef.child(postId).child("likeBy").updateChildValues([uid: "likes"]) { (err, db) in
                completion(err)
            }
        }
    }
}
