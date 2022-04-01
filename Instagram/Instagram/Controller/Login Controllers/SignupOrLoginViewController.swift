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
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.toLoginView, sender: self)
    }
    
    @IBAction func signupPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.toSignupView, sender: self)
    }
}
