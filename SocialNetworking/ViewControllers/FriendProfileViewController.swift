//
//  FriendProfileViewController.swift
//  SocialNetworking
//
//  Created by stephanie Cappello on 12/1/18.
//  Copyright © 2018 stephanie Cappello. All rights reserved.
//

import UIKit
import SVProgressHUD

class FriendProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var postArr: [PostDetail] = []
    var user: User?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var userProfilePhotoImgView: UIImageView!
    @IBOutlet weak var userDisplayNameLbl: UILabel!
    @IBOutlet weak var postNumLbl: UILabel!
    @IBOutlet weak var followersNumLbl: UILabel!
    @IBOutlet weak var followingNumLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDisplayNameLbl.text = user?.displayName
        userProfilePhotoImgView.image = user?.img
        userProfilePhotoImgView = UIImageView().squareToCircle(imgView: userProfilePhotoImgView)
        postNumLbl.text = String(user?.postCount ?? 0)
        FirebaseHandler.shared.retrievePostsForUser(userid: user?.id ?? "") { (pD) in
            self.postArr = pD
            SVProgressHUD.show()
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                self.collectionView.reloadData()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width/3.0
        let yourHeight = yourWidth
        
        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionCell", for: indexPath) as? PostPhotoCollectionViewCell
        let post = postArr[indexPath.row]
        cell?.imgView.image = post.postImage
        return cell!
    }
}
