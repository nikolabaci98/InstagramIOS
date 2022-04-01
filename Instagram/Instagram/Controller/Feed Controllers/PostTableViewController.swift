//
//  TableViewController.swift
//  Instagram
//
//  Created by Nikola Baci on 3/24/22.
//

import UIKit
import Parse
import AlamofireImage
import MessageInputBar

class PostTableViewController: UITableViewController, MessageInputBarDelegate {
    
    var posts = [PFObject]()
    let myRefreshControl = UIRefreshControl()
    let commentBar = MessageInputBar()
    var showsCommentBar = false
    var selectedPost: PFObject!
    var userToShowProfile: PFUser!
    
    override var inputAccessoryView: UIView? {
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return showsCommentBar
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = K.estimatedRowHeight
        myRefreshControl.addTarget(self, action: #selector(pullRefreshPosts), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
        tableView.keyboardDismissMode = .interactive
        commentBar.inputTextView.placeholder = K.commentTextPlaceholder
        commentBar.sendButton.title = K.commentPostButtonName
        commentBar.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    

    func showUserProfile(user: PFUser) {
        userToShowProfile = user
        performSegue(withIdentifier: K.showUserProfile, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.showUserProfile {
            let detailVC = segue.destination as! ProfileViewController
            detailVC.user = userToShowProfile
        }
    }
    
    @objc func keyboardWillBeHidden(note: Notification) {
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
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
        query.includeKeys(["author", "comments", "comments.author"])
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
        let post = posts[section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        return comments.count + 2 //one for the post one for the comment label
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.section]
        let comments = post["comments"] as? [PFObject]

        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.postTableViewCellID) as! PostTableViewCell
            cell.configure(with: post, self)
            return cell
            
        } else if indexPath.row <= comments?.count ?? 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.commentTableViewCellID) as! CommentTableViewCell
            cell.configure(comment: (comments?[indexPath.row - 1])!)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.addCommentTableViewCellID)!
            return cell
        }
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        PFUser.logOut()
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = main.instantiateViewController(withIdentifier: K.loginVCID)
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else {return}
        
        delegate.window?.rootViewController = loginVC
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.section]
        let comments = post["comments"] as? [PFObject] ?? []
        
        if indexPath.row == comments.count + 1 {
            showsCommentBar = true
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()
            selectedPost = post
        }


    }
    

    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        //create the comment
        let comment = PFObject(className: "Comments")
        comment["author"] = PFUser.current()!
        comment["post"] = selectedPost
        comment["text"] = text

        selectedPost.add(comment, forKey: "comments")
        selectedPost.saveInBackground { success, error in
            if error != nil {
                print("An error occurred while trying to save the comment")
            } else {
                print("Comment saved successfully")
                self.tableView.reloadData()
            }
        }
        
        //clear and dismiss the input bar
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
}
