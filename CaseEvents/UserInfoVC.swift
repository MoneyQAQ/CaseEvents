//
//  SecondViewController.swift
//  CaseEvents
//
//  Created by Xiaohan Wang on 4/29/16.
//  Copyright © 2016 Xiaohan Wang. All rights reserved.
//

import UIKit

class UserInfoVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var eventCount:UInt = 0
    var eref = Firebase(url: "https://flickering-heat-8881.firebaseio.com/Events")
    var events = [NSDictionary]()
    var e2 = [NSDictionary]()
    
    let ref = Firebase(url: "https://flickering-heat-8881.firebaseio.com/Users")
    
    var userData = UserModel.currentUser.providerData
    var faves = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let email = userData["email"] as? String
        let uid = UserModel.currentUser.uid
        test.text = email
        
        let userimageurl = userData["profileImageURL"] as? String
        if let checkedUrl = NSURL(string: userimageurl!) {
            profileimage.contentMode = .ScaleAspectFit
            downloadImage(checkedUrl)
        }
        
        
        faves = UserModel.faved.characters.split{$0 == "/"}.map(String.init)
        
        favs.delegate = self
        favs.dataSource = self
        
        /*
        eref.observeEventType(.Value, withBlock: { snapshot in
            self.eventCount = snapshot.childrenCount
        })
 */
        self.events = EventTableViewController.events
        
        for item in events {
            print(item)
            let en = item["name"] as? String
            if faves.contains(en!) {
                e2.append(item)
            }
        }
        favs.reloadData()
        
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    func downloadImage(url: NSURL){
        print("Download Started")
        print("lastPathComponent: " + (url.lastPathComponent ?? ""))
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                print(response?.suggestedFilename ?? "")
                print("Download Finished")
                self.profileimage.image = UIImage(data: data)
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let event = e2[indexPath.row]
        let dequeued: AnyObject = tableView.dequeueReusableCellWithIdentifier("myeventcell", forIndexPath: indexPath)
        let cell = dequeued as! FavEventCell
        cell.eventName.text = event["name"] as? String
        cell.location.text = event["location"] as? String
        return cell
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return e2.count
    }
    
    
    func loadDataFromFirebase() {
            }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var test: UILabel!
    @IBOutlet weak var profileimage: UIImageView!
    @IBOutlet weak var favs: UITableView!
    

}

