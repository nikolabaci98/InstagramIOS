//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Nikola Baci on 3/25/22.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileTableView: UITableView!
    var posts = [PFObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileTableView.allowsSelection = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        populateProfile()
    }
    
    func populateProfile() {
        print("updating tableview")
        let user = PFUser.current()
        let query = PFQuery(className: "Posts")
        query.includeKey("author")
        query.order(byDescending: "createdAt")
        query.limit = 20
        query.whereKey("author", equalTo: user!)
        
        query.findObjectsInBackground { posts, error in
            if error != nil {
                print(error!)
            } else {
                self.posts = posts!
                self.profileTableView.reloadData()
            }
        }
        usernameLabel.text = user?.username
        if user?["profile_image"] != nil {
            let imageFile = user?["profile_image"] as! PFFileObject
            let urlString = imageFile.url!
            profileImage.af.setImage(withURL: URL(string: urlString)!)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell") as! ProfileTableViewCell
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
        
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        cell.postImage.af.setImage(withURL: URL(string: urlString)!)
        
        cell.deleteButton.tag = indexPath.row
        
        return cell
    }
    
    @IBAction func deletePostPressed(_ sender: UIButton) {
        print("delete button pressed")
        let index = sender.tag
        let postToDelete = posts[index]
        print(postToDelete)
        
        let query = PFQuery(className: "Posts")
        query.whereKey("objectId", equalTo: postToDelete.objectId)
        
        query.findObjectsInBackground { posts , error in
            if error != nil {
                print("Post does not exits")
            } else {
                for post in posts! {
                    print("Deleting post")
                    post.deleteInBackground()
                }
            }
            self.populateProfile()
        }
    }
}
