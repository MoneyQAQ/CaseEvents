//
//  SecondViewController.swift
//  CaseEvents
//
//  Created by Xiaohan Wang on 4/29/16.
//  Copyright © 2016 Xiaohan Wang. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    let ref = Firebase(url: "https://flickering-heat-8881.firebaseio.com")
    
    var userData = UserModel.currentUser.providerData

    override func viewDidLoad() {
        super.viewDidLoad()
        let email = userData["email"] as? String
        test.text = email
        let newUserInfo = ["email": email!, "age": "19"]
        let newRef = ref.childByAutoId()
        newRef.setValue(newUserInfo)
        ref.observeEventType(.Value, withBlock: { snapshot in
            for item in snapshot.children {
                let child = item as! FDataSnapshot
                if child.value.valueForKey("email") as? String == email {
                    self.test2.text = child.value.valueForKey("age") as? String
                }
            }
        })
        print(userData)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var test: UILabel!
    @IBOutlet weak var test2: UILabel!
    

}

