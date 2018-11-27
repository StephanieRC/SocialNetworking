//
//  FriendListTableViewCell.swift
//  SocialNetworking
//
//  Created by stephanie Cappello on 11/26/18.
//  Copyright © 2018 stephanie Cappello. All rights reserved.
//

import UIKit

class FriendListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var displayNameLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.layer.cornerRadius = imgView.frame.size.width/2
        imgView.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
