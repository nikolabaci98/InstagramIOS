//
//  Post.swift
//  Instagram
//
//  Created by Nikola Baci on 3/31/22.
//

import Foundation
import Parse

class Post {
    
    var post: PFObject
    var user: PFUser
    
    init(post: PFObject) {
        self.post = post
        self.user = post["author"] as! PFUser
    }
    
    func getUsername() -> String {
        return user.username!
    }
    
    func getUsernameAndCaption() -> NSMutableAttributedString? {
        
        let caption = (post["caption"] as? String)!
        if caption == "" {
            return nil
        }
        let username = user.username!
        
        let attrs = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)]
        let strToDisplay = NSMutableAttributedString(string: username, attributes: attrs)
        let attrCaption = NSMutableAttributedString(string: caption)
        
        strToDisplay.append(NSAttributedString(" "))
        strToDisplay.append(attrCaption)
        
        return strToDisplay
    }
    
    func getUserProfilePicture() -> URL? {
        if user["profile_image"] != nil {
            let profileImageFile = user["profile_image"] as! PFFileObject
            let urlString = profileImageFile.url!
            return URL(string: urlString)
        }
        return nil
        
    }
    
    func getPostImage() -> URL? {
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        return URL(string: urlString)
    }
}
