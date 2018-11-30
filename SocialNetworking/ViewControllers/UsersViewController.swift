//
//  UsersViewController.swift
//  SocialNetworking
//
//  Created by stephanie Cappello on 11/20/18.
//  Copyright © 2018 stephanie Cappello. All rights reserved.
//

import UIKit
import SVProgressHUD
import FirebaseAuth

//TODO: Optimize this, should not reload whole data with firebase call each time button is selected

class UsersViewController: UIViewController, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource {
    
    var userKeys: [(user: User, friend: Bool)] = []
    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUsers()
    }
    
    func loadUsers(){
        SVProgressHUD.show()
        FirebaseHandler.shared.fetchUsers(){
            (userKeyArr) in
            DispatchQueue.main.async {
                self.userKeys = userKeyArr ?? []
                SVProgressHUD.dismiss()
                self.tblView.reloadData()
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userKeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "usersAllCell") as! UsersTableViewCell
        cell.selectionStyle = .none
        let user = userKeys[indexPath.row].user
        cell.nameLbl.text = user.name
        cell.profileImgView.image = user.img
        cell.addFriendBtn.tag = indexPath.row
        if userKeys[indexPath.row].friend == false{
            cell.addFriendBtn.setImage(UIImage(named: "icons8-add-user-male-50"), for: .normal)
            cell.addFriendBtn.setImage(UIImage(named: "icons8-add-user-male-filled-50"), for: .highlighted)
            cell.addFriendBtn.addTarget(self, action: #selector(addFriendClicked), for: .touchUpInside)
        }else{
            cell.addFriendBtn.setImage(UIImage(named: "icons8-unfriend-50"), for: .normal)
            cell.addFriendBtn.setImage(UIImage(named: "icons8-unfriend-filled-50"), for: .highlighted)
            cell.addFriendBtn.addTarget(self, action: #selector(removeFriendClicked), for: .touchUpInside)
            
        }
        return cell
    }
    
    @objc func addFriendClicked(_ sender: UIButton){
        let user = userKeys[sender.tag].user
        FirebaseHandler.shared.addFriend(friendId: user.id, userid: (Auth.auth().currentUser?.uid)!) { (friendMsg) in
            print(friendMsg)
            self.loadUsers()
        }
    }
    
    @objc func removeFriendClicked(_ sender: UIButton){
        let user = userKeys[sender.tag].user
        FirebaseHandler.shared.removeFriend(friendId: user.id, userid: (Auth.auth().currentUser?.uid)!) { (friendMsg) in
            print(friendMsg)
            self.loadUsers()
        }
    }
    
    
    @IBAction func mapBtn(_ sender: UIBarButtonItem) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "userMapViewController") as? MapGoogleViewController{
            controller.userArr = userKeys
            present(controller, animated: true)
        }
    }
}
