import CoreGraphics


struct K {
    static let userLoggedin = "UserLoggedin"
    static let toLoginView = "LoginSegue"
    static let toSignupView = "SignupSegue"
    static let loginToHomeSegue = "LoginToHome"
    static let signupToHomeSegue = "SignupToHome"
    static let homeToPostSegue = "HomeToCamera"
    static let cameraToComposePost = "CameraToComposePost"
    static let showUserProfile = "ShowUserProfile"
    static let profileToDetail = "ProfileToDetail"
    static let detailToProfile = "DetailToProfile"
    
    static let postTableViewCellID = "PostTableViewCell"
    static let commentTableViewCellID = "CommentTableViewCell"
    static let addCommentTableViewCellID = "AddCommentTableViewCell"
    static let profileTableViewCellID = "ProfileTableViewCell"
    
    static let loginVCID = "LoginViewController"
    
    static let imgPlaceholder = "image_placeholder"
    static let estimatedRowHeight: CGFloat = 400
    static let commentTextPlaceholder = "Add a comment..."
    static let commentPostButtonName = "Post"
}
