//
//  LoginViewController.swift
//  Instagram
//
//  Created by Nikola Baci on 3/22/22.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        
        if username != "" && password != "" {
            PFUser.logInWithUsername(inBackground: username, password: password) { user, error in
                
                if let error = error {
                    print("Error on login: \(error)")
                    return
                }
                
                if user != nil {
                    self.performSegue(withIdentifier: K.loginToHomeSegue, sender: self)
                } else {
                    print("Error: user came back nil")
                }
            }
        }
    }
    
    @IBAction func signupPressed(_ sender: Any) {
        performSegue(withIdentifier: K.toSignupView, sender: self)
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
