//
//  HomeViewController.swift
//  SocialNetworking
//
//  Created by stephanie Cappello on 11/29/18.
//  Copyright © 2018 stephanie Cappello. All rights reserved.
//

import UIKit
import SVProgressHUD

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var allPosts: [PostDetail] = []
    @IBOutlet weak var tblView: UITableView!
    let currUser = FirebaseHandler.shared.getCurrentUid()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(HomeViewController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.red
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        retrievePosts()
        tblView.addSubview(self.refreshControl)
    }
    
    func retrievePosts(){
        SVProgressHUD.show()
        FirebaseHandler.shared.retrievePostDetails { (allPosts) in
            self.allPosts = allPosts
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                self.tblView.reloadData()
            }
        }
    }

    @IBAction func addPostBtn(_ sender: UIBarButtonItem) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "AddPostViewController") as? AddPostViewController{
            present(controller, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostDetailTableViewCell") as? PostDetailTableViewCell
        let post = allPosts[indexPath.row]
        cell?.tag = indexPath.row
        cell?.userPhotoImgView.image = post.postUserImage
        cell?.displayNameLabel.text = post.name
        cell?.postPhotoImgView.image = post.postImage
        cell?.likeImgView.image = post.isLike ? UIImage(named: "like") : UIImage(named: "unlike")
        cell?.timeLbl.text = dayDifference(from: post.timestamp)
        cell?.likesBtn.titleLabel?.text = post.like == 1 ? "1 like" : "\(post.like ?? 0) likes"
        cell?.likeBtn.postIdentifier = indexPath.row
        cell?.likeBtn.associatedIndexPath = indexPath
        cell?.likeBtn.addTarget(self, action: #selector(likeBtnPressed), for: .touchUpInside)
        cell?.commentBtn.postIdentifier = indexPath.row
        cell?.commentBtn.addTarget(self, action: #selector(addCommentBtnPressed), for: .touchUpInside)
        cell?.shareBtn.postIdentifier = indexPath.row
        cell?.shareBtn.addTarget(self, action: #selector(shareBtnPressed), for: .touchUpInside)
        cell?.viewAllCommentsBtn.postIdentifier = indexPath.row
        cell?.viewAllCommentsBtn.addTarget(self, action: #selector(viewAllCommentsBtnPressed), for: .touchUpInside)
        cell?.commentPreviewLbl.text = "\(post.commentby.first?.key) - \(post.commentby.first?.value)"
        return cell!
    }
    
    @objc func likeBtnPressed(_ sender: IdentifiedButton){
        let index = sender.postIdentifier ?? 0
        let currPost = allPosts[index]
        allPosts[index].isLike = !(currPost.isLike)
        if !(currPost.isLike) == false{
            let removeMe = currPost.likeby.firstIndex(of: String(self.currUser))
            allPosts[index].likeby.remove(at: removeMe!)
            allPosts[index].like = (currPost.like ?? 1) - 1
        }else{
            allPosts[index].likeby.append(currUser)
            allPosts[index].like = (currPost.like ?? 1) + 1
        }
        DispatchQueue.main.async {
            self.tblView.reloadRows(at: [sender.associatedIndexPath!], with: .none)
        }
        FirebaseHandler.shared.setPostLike(postId: currPost.imageRef,
                                           uid: currUser,
                                           currentlyLiked: currPost.isLike) { (err) in
                                            if err == nil{
                                                //self.retrievePosts()
//                                                if currPost.isLike == true{
//                                                    sender.associatedImage?.image = UIImage(named: "unlike")
//                                                }
//                                                if currPost.isLike == true{
//                                                    if let removeMe = currPost.likeby.firstIndex(of: String(self.currUser)){
//                                                        self.allPosts[index].likeby.remove(at: removeMe)
//                                                        self.allPosts[index].like = (currPost.like ?? 1) - 1
//                                                    }else{
//                                                        self.allPosts[index].likeby.append(self.currUser)
//                                                        self.allPosts[index].like = (currPost.like ?? 1) + 1
//                                                    }
//                                                    self.allPosts[index].isLike = !currPost.isLike
//
//                                                    tblView.viewWithTag(index)
//                                                    image = post.isLike ? UIImage(named: "like") : UIImage(named: "unlike")
//                                                }
                                            }
        }
    }
    
    @objc func addCommentBtnPressed(_ sender: IdentifiedButton){
        print(sender.postIdentifier)
    }
    
    @objc func shareBtnPressed(_ sender: IdentifiedButton){
        print(sender.postIdentifier)
    }
    
    @objc func viewAllCommentsBtnPressed(_ sender: IdentifiedButton){
        print(sender.postIdentifier)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        FirebaseHandler.shared.retrievePostDetails { (allPosts) in
            self.allPosts = allPosts
            DispatchQueue.main.async {
                self.tblView.reloadData()
            }
        }
        refreshControl.endRefreshing()
    }
    
    @IBAction func unwindToContainerVC(segue: UIStoryboardSegue) {
    }
    
    /*
     https://stackoverflow.com/questions/39345101/swift-check-if-a-timestamp-is-yesterday-today-tomorrow-or-x-days-ago
    */
    func dayDifference(from interval : TimeInterval) -> String
    {
        let calendar = NSCalendar.current
        let date = Date(timeIntervalSince1970: interval)
        if calendar.isDateInYesterday(date) { return "Yesterday" }
        else if calendar.isDateInToday(date) { return "Today" }
        else {
            let startOfNow = calendar.startOfDay(for: Date())
            let startOfTimeStamp = calendar.startOfDay(for: date)
            let components = calendar.dateComponents([.day], from: startOfNow, to: startOfTimeStamp)
            let day = components.day!
            if day < 1 { return "\(abs(day)) days ago" }
            else { return "In \(day) days" }
        }
    }
}
