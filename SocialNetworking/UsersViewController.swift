//
//  UsersViewController.swift
//  SocialNetworking
//
//  Created by stephanie Cappello on 11/20/18.
//  Copyright © 2018 stephanie Cappello. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource {
    
    var userKeys: [String] = []
    
    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseHandler.shared.fetchUsers(){
            (userKeyArr) in
            DispatchQueue.main.async {
                self.userKeys = userKeyArr ?? []
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
        cell.nameLbl.text = userKeys[indexPath.row]
        return cell
    }
    
    
}
