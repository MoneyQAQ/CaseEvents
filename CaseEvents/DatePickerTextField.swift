//
//  DatePickerTextField.swift
//  CaseEvents
//
//  Created by Xiaohan Wang on 5/1/16.
//  Copyright © 2016 Xiaohan Wang. All rights reserved.
//

import UIKit

class DatePickerTextField: UITextField
{
    private var datePicker: UIDatePicker!
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        datePicker = UIDatePicker()
        datePicker.backgroundColor = UIColor.whiteColor()
        self.clearButtonMode = .Never
        datePicker.datePickerMode = .DateAndTime
        datePicker.addTarget(self, action: #selector(dateChanged), forControlEvents: .ValueChanged)
        inputView = datePicker
    }
    
    func dateChanged()
    {
        let currentDate = NSDate()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd yyyy @hh:mm a"
        let dateStr = dateFormatter.stringFromDate(datePicker.date)
        
        if self.tag == 1
        {
            if datePicker.date.isLessThanDate(currentDate)
            {
                let alert = UIAlertView(title: "CaseEvents",
                                        message: "Start date cannot be less than today",
                                        delegate: nil,
                                        cancelButtonTitle: "OK")
                alert.show()
            }
            else
            {
                self.text = dateStr
            }
        }
        else
        {
            if datePicker.date.isSameAsDate(currentDate)   ||
                datePicker.date.isLessThanDate(currentDate)
            {
                let alert = UIAlertView(title: "CaseEvents",
                                        message: "End date cannot be equal or less than today",
                                        delegate: nil,
                                        cancelButtonTitle: "OK")
                alert.show()
            }
            else
            {
                self.text = dateStr
            }
        }
    }
}

extension NSDate {
    func isGreaterThanDate(dateToCompare : NSDate) -> Bool {
        var isGreater = false
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending {
            isGreater = true
        }
        return isGreater
    }
    
    func isLessThanDate(dateToCompare : NSDate) -> Bool {
        var isLess = false
        if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending {
            isLess = true
        }
        return isLess
    }
    
    func isSameAsDate(dateToCompare : NSDate) -> Bool {
        var isEqualTo = false
        if self.compare(dateToCompare) == NSComparisonResult.OrderedSame {
            isEqualTo = true
        }
        return isEqualTo
    }
    
}