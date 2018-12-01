//
//  FriendsListViewController.swift
//  SocialNetworking
//
//  Created by stephanie Cappello on 11/27/18.
//  Copyright © 2018 stephanie Cappello. All rights reserved.
//

import UIKit
import SVProgressHUD

class FriendsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblview: UITableView!
    var friendsList: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SVProgressHUD.show()
        FirebaseHandler.shared.retrieveFriendList { (users) in
            self.friendsList = users ?? []
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                self.tblview.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell") as! FriendListTableViewCell
        let friend = friendsList[indexPath.row]
        cell.nameLbl.text = friend.name
        cell.displayNameLbl.text = friend.displayName
        cell.phoneLbl.text = friend.phoneNum
        cell.imgView.image = friend.img
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "FriendProfileViewController") as? FriendProfileViewController{
            controller.user = friendsList[indexPath.row]
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}
