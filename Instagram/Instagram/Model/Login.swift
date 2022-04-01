//
//  Login.swift
//  Instagram
//
//  Created by Nikola Baci on 3/27/22.
//

import Foundation
import Parse

class LoginBrain {
    var username: String?
    var password: String?
    var delegate: LoginViewController?
    
    init(username: String, password: String, _ delegate: LoginViewController) {
        self.username = username
        self.password = password
        self.delegate = delegate
    }
    
    func login() {
        if username != "" && password != "" {
            PFUser.logInWithUsername(inBackground: username!, password: password!) { user, error in
                
                if let error = error {
                    print("Error on login: \(error)")
                    return
                }
                
                if user != nil {
                    self.delegate?.userAuthenticated()
                } else {
                    print("Error: user came back nil")
                }
            }
        }
    }
}
