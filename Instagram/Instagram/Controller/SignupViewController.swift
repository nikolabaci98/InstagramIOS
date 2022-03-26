//
//  SignupViewController.swift
//  Instagram
//
//  Created by Nikola Baci on 3/22/22.
//

import UIKit
import Parse

class SignupViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        usernameTextField.text = ""
        fullnameTextField.text = ""
        passwordTextField.text = ""
    }

    @IBAction func signupPressed(_ sender: UIButton) {
        let user = PFUser()
        
        let username = usernameTextField.text
        let password = passwordTextField.text
        let fullname = fullnameTextField.text
        
        if password != "" && username != "" && fullname != "" {
            user.username = username
            user.password = password
            user["fullname"] = fullname
            
            user.signUpInBackground { success, error in
                if let error = error {
                    print("Error on sign up: \(error)")
                    return
                }
                self.performSegue(withIdentifier: K.signupToHomeSegue, sender: self)
            }
        }
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.toLoginView, sender: self)
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
