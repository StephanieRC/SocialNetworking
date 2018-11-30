//
//  HomeViewController.swift
//  SocialNetworking
//
//  Created by stephanie Cappello on 11/29/18.
//  Copyright © 2018 stephanie Cappello. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    var allPosts: [PostDetail] = []

    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseHandler.shared.retrievePostDetails { (allPosts) in
            self.allPosts = allPosts
            DispatchQueue.main.async {
                self.tblView.reloadData()
            }
        }
    }

    @IBAction func unwindToContainerVC(segue: UIStoryboardSegue) {
    }

    @IBAction func addPostBtn(_ sender: UIBarButtonItem) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "AddPostViewController") as? AddPostViewController{
            present(controller, animated: true)
        }
    }
}
