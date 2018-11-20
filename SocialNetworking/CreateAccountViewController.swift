//
//  CreateAccountViewController.swift
//  SocialNetworking
//
//  Created by stephanie Cappello on 11/20/18.
//  Copyright © 2018 stephanie Cappello. All rights reserved.
//

import UIKit
import 

class CreateAccountViewController: MRKBaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblView: UITableView!
    let textFieldArr = ["Display Name", "Email", "Password", "Phone Number", "Birthdate", "Language", "Address", "City", "State", "Country", "Zipcode"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    @IBAction func selectImg(_ sender: UIButton) {
    }
    
    @IBAction func signUpBtn(_ sender: UIButton) {
        //FirebaseHandler.shared.signUp()
        //navigationController?.popViewController(animated: true)
    }
}
