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
    @IBOutlet weak var alert: UILabel!
    
    let uref = Firebase(url: "https://flickering-heat-8881.firebaseio.com/Users")
    
    @IBAction func saveUser(sender: AnyObject) {
        if let newemail = email.text, newpassword = password.text {
            let ref = Firebase(url: "https://flickering-heat-8881.firebaseio.com")
            ref.createUser(newemail, password: newpassword,
                           withValueCompletionBlock: { error, result in
                            if error != nil {
                                self.alert.text = "User name already exists!"
                            } else {
                                let uid = result["uid"] as? String
                                let newUserInfo = ["uid": uid!, "username": "None", "email": newemail]
                                let newRef = self.uref.childByAutoId()
                                newRef.setValue(newUserInfo)
                                print("Successfully created user account with uid: \(uid)")
                                self.performSegueWithIdentifier("accountcreated", sender: nil)
                            }
            })
        }
        else {
            self.alert.text = "Both fields are required!"
        }
    }

    @IBAction func cancel(sender: AnyObject) {
        self.performSegueWithIdentifier("accountcreated", sender: nil)
    }
}
