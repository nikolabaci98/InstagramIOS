//
//  TableViewController.swift
//  Instagram
//
//  Created by Nikola Baci on 3/24/22.
//

import UIKit
import Parse
import AlamofireImage

class TableViewController: UITableViewController {
    
    var posts = [PFObject]()
    let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 400
        tableView.allowsSelection = false
        myRefreshControl.addTarget(self, action: #selector(pullRefreshPosts), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
    }
    
    @objc func pullRefreshPosts() {
        getPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getPosts()
        
    }
    
    func getPosts() {
        let query = PFQuery(className: "Posts")
        query.includeKey("author")
        query.order(byDescending: "createdAt")
        query.limit = 20
        myRefreshControl.endRefreshing()
        query.findObjectsInBackground { posts, error in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
            }
        }
        
    }
    
    @IBAction func onCameraPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: K.homeToPostSegue, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell") as! PostTableViewCell
        let post = posts[indexPath.row]
        
        let user = post["author"] as! PFUser
        
        let boldText = user.username!
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
        let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)

        let normalText = (post["caption"] as? String)!
        let normalString = NSMutableAttributedString(string:normalText)
        attributedString.append(NSAttributedString(" "))
        attributedString.append(normalString)
        
        cell.usernameAndCaptionLabel.attributedText = attributedString
        cell.usernameLabel.text = user.username!
        
        print(user)
        
        if user["profile_image"] != nil {
            let profileImageFile = user["profile_image"] as! PFFileObject
            let urlString1 = profileImageFile.url!
            cell.userProfileImage.layer.cornerRadius = cell.userProfileImage.frame.width / 2
            cell.userProfileImage.af.setImage(withURL: URL(string: urlString1)!)
        }
          
        
        
        let imageFile = post["image"] as! PFFileObject
        let urlString2 = imageFile.url!
        cell.postImage.af.setImage(withURL: URL(string: urlString2)!)
        
        return cell
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        PFUser.logOut()
        dismiss(animated: true)
    }
}
