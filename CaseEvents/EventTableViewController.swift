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
    var events = [NSDictionary]()
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let event = events[indexPath.row]
        let dequeued: AnyObject = tableView.dequeueReusableCellWithIdentifier("eventcell", forIndexPath: indexPath)
        let cell = dequeued as! EventCell
        cell.eventName.text = event["name"] as? String
        cell.location.text = event["location"] as? String
        return cell
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        ref.observeEventType(.Value, withBlock: { snapshot in
            self.eventCount = snapshot.childrenCount
        })
        loadDataFromFirebase()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }


    func loadDataFromFirebase() {
        ref.observeEventType(.Value, withBlock: { snapshot in
            var tempItems = [NSDictionary]()
            for item in snapshot.children {
                let child = item as! FDataSnapshot
                let name = child.value as! NSDictionary
                tempItems.append(name)
            }
            self.events = tempItems
            self.tableView.reloadData()
        })
    }

}
