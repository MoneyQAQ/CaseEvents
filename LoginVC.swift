//
//  LoginVC.swift
//  CaseEvents
//
//  Created by A❤Y on 4/29/16.
//  Copyright © 2016 Xiaohan Wang. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func performLogin(sender: AnyObject) {
        if let useremail = email.text{
            if let userpassword = password.text {
                let ref = Firebase(url: "https://flickering-heat-8881.firebaseio.com")
                ref.authUser(useremail, password: userpassword,
                    withCompletionBlock: { error, authData in
                        if error != nil {
                            // There was an error logging in to this account
                        } else {
                            self.performSegueWithIdentifier("loggedin", sender: nil)
                        }
                })
            }
        }
    }
    

}
