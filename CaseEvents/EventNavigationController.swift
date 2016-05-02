//
//  EventNavigationController.swift
//  CaseEvents
//
//  Created by Xiaohan Wang on 5/1/16.
//  Copyright © 2016 Xiaohan Wang. All rights reserved.
//

import UIKit

class EventNavigationController: UINavigationController {

    override func viewDidLoad() {
        
        // sets the back button to white color
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
