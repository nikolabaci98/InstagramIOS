//
//  ProfileEditViewController.swift
//  Instagram
//
//  Created by Nikola Baci on 3/26/22.
//

import UIKit
import Parse

class ProfileEditViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        setupProfile()
    }
    
    func setupProfile() {
        let user = PFUser.current()
        
        if user?["profile_image"] != nil {
            let imageFile = user?["profile_image"] as! PFFileObject
            let urlString = imageFile.url!
            profileImage.af.setImage(withURL: URL(string: urlString)!)
        }
        fullnameTextField.text = user?["fullname"] as? String ?? ""
        emailTextField.text = user?.email ?? ""
        bioTextField.text = user?["bio"] as? String ?? ""
        
    }
    
    @IBAction func onSavePressed(_ sender: UIBarButtonItem) {
        let user = PFUser.current()
        let name = fullnameTextField.text
        if name != "" {
            user?["fullname"] = name
        }
        
        let email = emailTextField.text
        if email != "" {
            user?.email = email
        }
        
        let bio = bioTextField.text
        if bio != "" {
            user?["bio"] = bio
        }
        
        
        let imageData = profileImage.image!.pngData()
        let file = PFFileObject(name: "image.png", data: imageData!)
        user?["profile_image"] = file

        user?.saveInBackground { success, error in
            if let error = error {
                print("Error saving the post \(error)")
                return
            }
            print("saved image successfully")
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func onProfileImagePressed(_ sender: UITapGestureRecognizer) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
    
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker.sourceType = .camera
            } else {
                picker.sourceType = .photoLibrary
            }
    
            present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let image = info[.editedImage] as! UIImage
            let size = CGSize(width: 300, height: 300)
            let scaledImage = image.af.imageScaled(to: size)
    
            profileImage.image = scaledImage
            dismiss(animated: true, completion: nil)
        }
}
