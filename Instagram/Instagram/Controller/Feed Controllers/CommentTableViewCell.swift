//
//  CommentTableViewCell.swift
//  Instagram
//
//  Created by Nikola Baci on 3/31/22.
//

import UIKit
import Parse

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var commentUsernameAndTextLabel: UILabel!
    
    func configure(comment: PFObject) {
        let comment = Comment(with: comment)
        commentUsernameAndTextLabel.attributedText = comment.getUsernameAndComment()
    }
}
