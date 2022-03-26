//
//  CameraViewController.swift
//  Instagram
//
//  Created by Nikola Baci on 3/22/22.
//

import UIKit
import AlamofireImage
import Parse


class ComposePostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        postImageView.image = image
    }
    
    @IBAction func onSubmitPressed(_ sender: UIButton) {
        let post = PFObject(className: "Posts")
        post["author"] = PFUser.current()
        post["caption"] = captionTextField.text!
        
        
        let size = CGSize(width: 500, height: 500)
        let scaledImage = image?.af.imageScaled(to: size)
        
        
        let imageData = scaledImage?.pngData()
        let file = PFFileObject(name: "image.png", data: imageData!)
        post["image"] = file
        
        post.saveInBackground { success, error in
            if let error = error {
                print("Error saving the post \(error)")
                return
            }
            
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {

        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 100
            }
        }

    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += 100
            }
        }
    }
}
