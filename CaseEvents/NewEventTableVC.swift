//
//  NewEventTableVC.swift
//  CaseEvents
//
//  Created by Xiaohan Wang on 5/1/16.
//  Copyright © 2016 Xiaohan Wang. All rights reserved.
//

import UIKit

class NewEventTableVC: UITableViewController, UIImagePickerControllerDelegate, UIAlertViewDelegate, UINavigationControllerDelegate
{
    
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var organizerName: UITextField!
    @IBOutlet weak var startTime: DatePickerTextField!
    @IBOutlet weak var endTime: DatePickerTextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var cost: UITextField!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventDescription: UITextField!
    
    var imageURL = NSURL()
    var imagePath = String()
    
    @IBAction func tapToDismissKeyboard(sender: UITapGestureRecognizer)
    {
        dismissKeyboard()
    }
    
    @IBAction func uploadImage(sender: AnyObject)
    {
        let alert = UIAlertView(title: "CaseEvents",
                                message: "Select Source",
                                delegate: self,
                                cancelButtonTitle: "Cancel",
                                otherButtonTitles: "Photo Library", "Camera")
        alert.show()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // AlertView delegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if alertView.buttonTitleAtIndex(buttonIndex) == "Photo Library" {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
                imagePicker.allowsEditing = false
                dismissKeyboard()
                presentViewController(imagePicker, animated: true, completion: nil)
            }
            
        } else if alertView.buttonTitleAtIndex(buttonIndex) == "Camera" {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
                imagePicker.allowsEditing = false
                dismissKeyboard()
                presentViewController(imagePicker, animated: true, completion: nil)
            }
        }
        
    }
    
    // ImagePicker delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        eventImage.image = image
        
        let dirPaths = NSSearchPathForDirectoriesInDomains( .DocumentDirectory, .UserDomainMask, true)
        let docsDir: AnyObject = dirPaths[0]
        imagePath = docsDir.stringByAppendingPathComponent("image.png")
        UIImageJPEGRepresentation(image, 0.8)!.writeToFile(imagePath, atomically: true)
        imageURL = NSURL(fileURLWithPath: imagePath)
//        print("\(imageURL)")
        
        dismissViewControllerAnimated(true, completion: nil)
    }

    func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    
    
    var ref = Firebase(url: "https://flickering-heat-8881.firebaseio.com/Events")
    var base64String: NSString!
    
    @IBAction func createEvent(sender: AnyObject) {
        if let name = eventName.text, oname = organizerName.text, l = location.text, im = eventImage.image, c = cost.text, st = startTime.text, et = endTime.text, d = eventDescription.text {
            let imageData: NSData = UIImagePNGRepresentation(im)!
            self.base64String = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions())
            let imString = self.base64String
            let newEvent = ["name": name, "organizer": oname, "location": l, "image": imString, "cost": c, "startTime": st, "endTime": et, "description": d]
            let newRef = ref.childByAutoId()
            newRef.setValue(newEvent)
            navigationController?.popViewControllerAnimated(true)
        }
        else {
            let missingAlert = UIAlertView(title: "CaseEvents",
                                    message: "All fields are required!",
                                    delegate: self,
                                    cancelButtonTitle: "OK"
                                    )
            missingAlert.show()
        }
    }
    
    
    
}
