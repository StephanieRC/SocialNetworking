//
//  HomeViewController.swift
//  SocialNetworking
//
//  Created by stephanie Cappello on 11/29/18.
//  Copyright © 2018 stephanie Cappello. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
        cell?.userPhotoImgView.image = post.postUserImage
        cell?.displayNameLabel.text = post.name
        cell?.postPhotoImgView.image = post.postImage
        cell?.likeImgView.image = post.isLike ? UIImage(named: "like") : UIImage(named: "unlike")
        cell?.timeLbl.text = dayDifference(from: post.timestamp)
        cell?.likesLbl.text = "\(post.like) likes"
        cell?.commentPreviewLbl.text = "\(post.commentby.first?.key) - \(post.commentby.first?.value)"
        return cell!
    }
    
    @IBAction func unwindToContainerVC(segue: UIStoryboardSegue) {
    }
    
    func dayDifference(from interval : TimeInterval) -> String
    {
        let calendar = NSCalendar.current
        let date = Date(timeIntervalSince1970: interval)
        if calendar.isDateInYesterday(date) { return "Yesterday" }
        else if calendar.isDateInToday(date) { return "Today" }
            //else if calendar.isDateInTomorrow(date) { return "Tomorrow" }
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
