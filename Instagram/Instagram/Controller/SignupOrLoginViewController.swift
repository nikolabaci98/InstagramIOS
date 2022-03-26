//
//  SignupOrLoginViewController.swift
//  Instagram
//
//  Created by Nikola Baci on 3/22/22.
//

import UIKit
import Parse

class SignupOrLoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let currentUser = PFUser.current()
        if currentUser != nil {
            performSegue(withIdentifier: K.userLoggedin, sender: self)
        }
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        print("login")
        performSegue(withIdentifier: K.toLoginView, sender: self)
    }
    
    @IBAction func signupPressed(_ sender: UIButton) {
        print("signup")
        performSegue(withIdentifier: K.toSignupView, sender: self)
    }
}
