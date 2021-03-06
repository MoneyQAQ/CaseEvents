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
    
    let ref = Firebase(url: "https://flickering-heat-8881.firebaseio.com/Users")
    
    var userData = UserModel.currentUser.providerData
    
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
        
        
        ref.observeEventType(.Value, withBlock: { snapshot in
            for item in snapshot.children {
                let child = item as! FDataSnapshot
                if child.value.valueForKey("uid") as? String == uid {
                    let favsString = child.value.valueForKey("faved") as? String
                    let favs = favsString!.characters.split{$0 == "/"}.map(String.init)
                    for item in favs {
                        print(item)
                    }
                }
            }
        })
        
        favs.delegate = self
        favs.dataSource = self
        eref.observeEventType(.Value, withBlock: { snapshot in
            self.eventCount = snapshot.childrenCount
        })
        loadDataFromFirebase()
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
        let event = events[indexPath.row]
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
        return events.count
    }
    
    
    func loadDataFromFirebase() {
        eref.observeEventType(.Value, withBlock: { snapshot in
            var tempItems = [NSDictionary]()
            for item in snapshot.children {
                let child = item as! FDataSnapshot
                let name = child.value as! NSDictionary
                tempItems.append(name)
            }
            self.events = tempItems
            self.favs.reloadData()
        })
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var test: UILabel!
    @IBOutlet weak var profileimage: UIImageView!
    @IBOutlet weak var favs: UITableView!
    

}

