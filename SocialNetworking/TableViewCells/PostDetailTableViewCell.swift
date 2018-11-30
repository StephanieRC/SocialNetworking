//
//  PostDetailTableViewCell.swift
//  SocialNetworking
//
//  Created by stephanie Cappello on 11/30/18.
//  Copyright © 2018 stephanie Cappello. All rights reserved.
//

import UIKit

class PostDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var userPhotoImgView: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var postPhotoImgView: UIImageView!
    @IBOutlet weak var likeImgView: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var commentPreviewLbl: UILabel!
    @IBOutlet weak var viewAllCommentsBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
