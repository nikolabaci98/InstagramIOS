//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by Nikola Baci on 3/22/22.
//

import UIKit
import Parse

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameAndCaptionLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userStackView: UIStackView!
    var user: PFUser? = nil
    var delegate: PostTableViewController? = nil
    
    func configure(with post: PFObject, _ delegate: PostTableViewController) {
        self.delegate = delegate
        self.user = post["author"] as? PFUser
        userStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showUserProfile)))
        let post = Post(post: post)
        
        
        
        usernameLabel.text = post.getUsername()
        usernameAndCaptionLabel.attributedText = post.getUsernameAndCaption()
        
        userProfileImage.layer.cornerRadius = userProfileImage.frame.width / 2
        let profileImageURL = post.getUserProfilePicture()
        if let profileImageURL = profileImageURL {
            userProfileImage.af.setImage(withURL: profileImageURL)
        } else {
            userProfileImage.image = UIImage(named: K.imgPlaceholder)
        }
        
        let postImageURL = post.getPostImage()
        if let postImageURL = postImageURL {
            postImage.af.setImage(withURL: postImageURL)
        }
    }
    
    @objc func showUserProfile() {
        delegate?.showUserProfile(user: self.user!)
    }
    
}
