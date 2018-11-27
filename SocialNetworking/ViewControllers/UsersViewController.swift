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

class UsersViewController: UIViewController, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource {
    
    var userKeys: [User] = []
    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let user = userKeys[indexPath.row]
        cell.nameLbl.text = user.name
        cell.profileImgView.image = user.img
        cell.addFriendBtn.tag = indexPath.row
        cell.addFriendBtn.addTarget(self, action: #selector(addFriendClicked), for: .touchUpInside)
        return cell
    }
    
    @objc func addFriendClicked(_ sender: UIButton){
        let user = userKeys[sender.tag]
        FirebaseHandler.shared.addFriend(friendId: user.id, userid: (Auth.auth().currentUser?.uid)!) { (friendMsg) in
            print(friendMsg)
        }
    }
    
}
