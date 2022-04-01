//
//  Signup.swift
//  Instagram
//
//  Created by Nikola Baci on 3/31/22.
//

import Foundation
import Parse

class Signup {
    var username: String
    var password: String
    var fullname: String
    var delegate: SignupViewController
    
    init(username: String, password: String, fullname: String, _ delegate: SignupViewController) {
        self.username = username
        self.password = password
        self.fullname = fullname
        self.delegate = delegate
    }
    
    func signup() {
        let user = PFUser()
        if password != "" && username != "" && fullname != "" {
            user.username = username
            user.password = password
            user["fullname"] = fullname
            
            user.signUpInBackground { success, error in
                if let error = error {
                    print("Error on sign up: \(error)")
                    return
                }
                self.delegate.userCreated()
            }
        }
    }
}
