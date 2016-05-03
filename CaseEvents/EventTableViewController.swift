//
//  EventTableViewController.swift
//  CaseEvents
//
//  Created by A❤Y on 4/30/16.
//  Copyright © 2016 Xiaohan Wang. All rights reserved.
//

import UIKit

class EventTableViewController: UITableViewController {
    
    var eventCount:UInt = 0
    var ref = Firebase(url: "https://flickering-heat-8881.firebaseio.com/Events")
    var uref = Firebase(url: "https://flickering-heat-8881.firebaseio.com/Users")
    static var events = [NSDictionary]()
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let event = EventTableViewController.events[indexPath.row]
        let dequeued: AnyObject = tableView.dequeueReusableCellWithIdentifier("eventcell", forIndexPath: indexPath)
        let cell = dequeued as! EventCell
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
        if let base64String = event["image"] as? String {
            let decodedData = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions())
            let decodedImage = UIImage(data: decodedData!)!
            cell.im.image = decodedImage
        }
        if let date = event["startTime"] as? String {
            cell.month.text = date[0...2]
            cell.date.text = date[4...5]
        }
        if let c = event["cost"] as? String {
            cell.cost.text = c
        }
        cell.row = indexPath.row
        return cell
    }
    
     
    override func viewDidLoad() {
        super.viewDidLoad()
        let cuid = UserModel.currentUser.uid
        ref.observeEventType(.Value, withBlock: { snapshot in
            self.eventCount = snapshot.childrenCount
        })
        loadDataFromFirebase()
        uref.observeEventType(.Value, withBlock: { snapshot in
//            print(snapshot.value)
            for item in snapshot.children {
                let child = item as! FDataSnapshot
                if child.value.valueForKey("uid") as? String == cuid {
                    if let s = child.value.valueForKey("faved") as? String{
                        UserModel.faved = s
                    }
                    else {
                        UserModel.faved = ""
                    }
                }
            }
        })

    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EventTableViewController.events.count
    }


    func loadDataFromFirebase() {
        ref.observeEventType(.Value, withBlock: { snapshot in
            var tempItems = [NSDictionary]()
            for item in snapshot.children {
                let child = item as! FDataSnapshot
                let name = child.value as! NSDictionary
                tempItems.append(name)
            }
            EventTableViewController.events = tempItems
            self.tableView.reloadData()
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Cancel"
        navigationItem.backBarButtonItem = backItem
        if segue.identifier == "detail"
        {
            let destinationVC = segue.destinationViewController as! EventDetailVC
            let senderCell = sender as! EventCell
            destinationVC.row = senderCell.row
        }
    }

}

extension String {
    
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = startIndex.advancedBy(r.startIndex)
        let end = start.advancedBy(r.endIndex - r.startIndex)
        return self[Range(start ..< end)]
    }
}
