//
//  ButtonTableViewCell.swift
//  SocialNetworking
//
//  Created by stephanie Cappello on 11/21/18.
//  Copyright © 2018 stephanie Cappello. All rights reserved.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func signUpBtn(_ sender: UIButton) {
        FirebaseHandler.shared.signUp(email: <#T##String#>, pwd: <#T##String#>, name: <#T##String#>, birthdate: <#T##String#>, address: <#T##String#>)
    }
}
