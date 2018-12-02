//
//  Post.swift
//  SocialNetworking
//
//  Created by stephanie Cappello on 11/29/18.
//  Copyright © 2018 stephanie Cappello. All rights reserved.
//

import Foundation
import UIKit

struct UserPost {
    var postId: String
    var postDetail : PostDetail
}

struct PostDetail {
    var description : String
    var imageRef : String
    var like : Int?
    var timestamp : Double
    var userId : String
    var postImage : UIImage?
    var postUserImage : UIImage?
    var name : String?
    var isLike : Bool
    var likeby : [String]
    var commentby : [String : String]
}
