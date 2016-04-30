//
//  NewUserVC.swift
//  CaseEvents
//
//  Created by A❤Y on 4/29/16.
//  Copyright © 2016 Xiaohan Wang. All rights reserved.
//

import UIKit

class NewUserVC: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func saveUser(sender: AnyObject) {
        if let newemail = email.text{
            if let newpassword = password.text {
                let ref = Firebase(url: "https://flickering-heat-8881.firebaseio.com")
                ref.createUser(newemail, password: newpassword,
                    withValueCompletionBlock: { error, result in
                        if error != nil {
                            print("User account exists")
                        } else {
                            let uid = result["uid"] as? String
                            print("Successfully created user account with uid: \(uid)")
                            self.performSegueWithIdentifier("accountcreated", sender: nil)
                        }
                })
            }
        }
        else {
            print("Missing info")
        }
    }

}
