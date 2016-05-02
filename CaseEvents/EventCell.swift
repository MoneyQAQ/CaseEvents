//
//  EventCell.swift
//  CaseEvents
//
//  Created by A❤Y on 4/30/16.
//  Copyright © 2016 Xiaohan Wang. All rights reserved.
//

import UIKit
import EventKit

class EventCell: UITableViewCell {
    
    
    var row: Int?
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var oName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var im: UIImageView!
    @IBOutlet weak var cost: UILabel!
    
    @IBAction func addToFav(sender: AnyObject) {
        
    }
    
    
    
    @IBAction func add2Calendar(sender: UIButton)
    {
        let eventStore = EKEventStore()
        let startDateString = EventTableViewController.events[row!]["startTime"] as! String
        let endDateString = EventTableViewController.events[row!]["endTime"] as! String
        let location = EventTableViewController.events[row!]["location"] as! String
        let startNSDate = NSDate(dateString: startDateString)
        let endNSDate = NSDate(dateString: endDateString)
        if (EKEventStore.authorizationStatusForEntityType(.Event) != EKAuthorizationStatus.Authorized) {
            eventStore.requestAccessToEntityType(.Event, completion: {
                granted, error in
                self.createCalendarEvent(eventStore, title: self.eventName.text!, startDate: startNSDate, endDate: endNSDate, location: location)
            })
        } else {
            createCalendarEvent(eventStore, title: self.eventName.text!, startDate: startNSDate, endDate: endNSDate, location: location)
        }
        let alert = UIAlertView(title: "Success!",
                                message: "Saved\" " + self.eventName.text! + "\" to Calendar",
                                delegate: nil,
                                cancelButtonTitle: "Hurray!")
        alert.show()
    }
    
    // Creates an event in the EKEventStore. The method assumes the eventStore is created and accessible
    func createCalendarEvent(eventStore: EKEventStore, title: String, startDate: NSDate, endDate: NSDate, location: String?) {
        let event = EKEvent(eventStore: eventStore)
        
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.location = location
        event.calendar = eventStore.defaultCalendarForNewEvents
        do {
            try eventStore.saveEvent(event, span: .ThisEvent)
        } catch {
            print("Bad things happened")
        }
    }

}

extension NSDate
{
    convenience
    init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "MMM dd yyyy @hh:mm a"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let d = dateStringFormatter.dateFromString(dateString)!
        self.init(timeInterval:0, sinceDate:d)
    }
}
