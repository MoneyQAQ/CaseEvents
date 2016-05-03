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
        //let uid = UserModel.currentUser.uid
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
            let en = item["name"] as? String
            if faves.contains(en!) {
                e2.append(item)
            }
        }
        favs.reloadData()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        faves = UserModel.faved.characters.split{$0 == "/"}.map(String.init)
        self.events = EventTableViewController.events
        e2.removeAll()
        for item in events {
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
                self.profileimage.image = UIImage(data: data)
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let event = e2[indexPath.row]
        let dequeued: AnyObject = tableView.dequeueReusableCellWithIdentifier("myeventcell", forIndexPath: indexPath)
        let cell = dequeued as! FavEventCell
        if let ename = event["name"] as? String {
            cell.eventName.text = ename
        }
        if let l = event["location"] as? String {
            if let date = event["startTime"] as? String, ed = event["endTime"] as? String{
                if date[4...5] == ed[4...5] {
                    cell.location.text = date[13...20] + " - " + ed[13...20] + " | " + l
                }
                else {
                    cell.location.text = date[13...20] + " - " + ed[0...5] + " " + ed[13...20] + " | " + l
                }
            }
            else {
                cell.location.text = l
            }
        }
        if let oname = event["organizer"] as? String {
            cell.oName.text = oname
        }
        if let date = event["startTime"] as? String {
            cell.month.text = date[0...2]
            cell.date.text = date[4...5]
        }
        cell.row = indexPath.row
        return cell
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return e2.count
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back to favorites"
        navigationItem.backBarButtonItem = backItem
        if segue.identifier == "fdetail"
        {
            let destinationVC = segue.destinationViewController as! EventDetailVC
            let senderCell = sender as! FavEventCell
            destinationVC.row = senderCell.row
            destinationVC.isFav = true
            for e in EventTableViewController.events{
                if e["name"] as? String == senderCell.eventName.text {
                    print(e["image"])
                    destinationVC.iString = e["image"] as? String
                }
            }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var test: UILabel!
    @IBOutlet weak var profileimage: UIImageView!
    @IBOutlet weak var favs: UITableView!
    

}

