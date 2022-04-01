//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Nikola Baci on 3/25/22.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var bioLabel: UILabel!
    var user: PFUser? = nil
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
        if user == nil { //profile tab button, check self's profile
            user = PFUser.current()
        }
        
        if user != PFUser.current() {
            editProfileButton.isHidden = true
        }
        populateProfile()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.user = nil
    }
    
    @IBAction func editProfilePressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.profileToDetail, sender: self)
    }
    
    
    func populateProfile() {
        
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
        
        let bio = user?["bio"] as? String
        if bio == nil {
            bioLabel.isHidden = true
        } else {
            bioLabel.text = bio
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.profileTableViewCellID) as! ProfileTableViewCell
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
        
        if user != PFUser.current() {
            cell.deleteButton.isHidden = true
        }
        
        return cell
    }
    
    @IBAction func deletePostPressed(_ sender: UIButton) {
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
