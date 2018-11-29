//
//  HomeViewController.swift
//  SocialNetworking
//
//  Created by stephanie Cappello on 11/29/18.
//  Copyright © 2018 stephanie Cappello. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func unwindToContainerVC(segue: UIStoryboardSegue) {
    }

    @IBAction func addPostBtn(_ sender: UIBarButtonItem) {
        //present(<#T##viewControllerToPresent: UIViewController##UIViewController#>, animated: <#T##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
        performSegue(withIdentifier: "AddPostSegue", sender: nil)
    }
}
