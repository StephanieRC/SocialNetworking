//
//  ImageProfileTableViewCell.swift
//  SocialNetworking
//
//  Created by stephanie Cappello on 11/20/18.
//  Copyright © 2018 stephanie Cappello. All rights reserved.
//

import UIKit

class ImageProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func selectPhotoBtn(_ sender: UIButton) {
    }
    
}
