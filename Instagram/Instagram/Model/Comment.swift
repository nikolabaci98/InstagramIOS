//
//  Comment.swift
//  Instagram
//
//  Created by Nikola Baci on 3/31/22.
//

import Foundation
import Parse
import UIKit

class Comment {
    
    var comment: PFObject!
    
    init(with comment: PFObject) {
        self.comment = comment
    }
    
    func getUsernameAndComment() -> NSMutableAttributedString {
        let user = comment["author"] as! PFUser
        let boldText = user.username!
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
        let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)

        let normalText = (comment["text"] as? String)!
        let normalString = NSMutableAttributedString(string:normalText)
        attributedString.append(NSAttributedString(" "))
        attributedString.append(normalString)
        
        return attributedString
    }
    
}
