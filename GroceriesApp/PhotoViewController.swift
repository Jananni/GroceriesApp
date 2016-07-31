//
//  PhotoViewController.swift
//  GroceriesApp
//
//  Created by Jananni Rathnagiri on 7/13/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import UIKit
import MobileCoreServices
import RealmSwift


class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var CameraTwo: UIButton!
    @IBOutlet weak var imageDisplay: UIImageView!  //INSTEAD OF IMAGEVIEW
    @IBOutlet weak var noteNameTextField: UITextField!
    @IBOutlet weak var noteDateTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var notificationCheckbox: CheckBox!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var daysLeftLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!



    let picker = UIImagePickerController()   //INSTEAD OF IMAGEPICKER
    let notificationFacade = MRLocalNotificationFacade.defaultInstance()

    var dateFromDatePicker: NSDate = SettingsHelper.datePickerTime
    //    var dateFromDatePickertemp: NSDate = NSDateComponents(coder: Settin)  //day from settings and time chosen
    var note: GroceryItem?

    var activityIndicator:UIActivityIndicatorView!
    var originalTopMargin:CGFloat!

    var settingsViewController: SettingsViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        //CHANGE FONT?
        saveBarButton.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Arial", size: 15)!], forState: UIControlState.Normal)
        picker.delegate = self

    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }




    func initializeDateWithTime(date:NSDate,hrs:Int,minutes:Int, day:Int) -> NSDate{
        let today = date
        let calendar:NSCalendar = NSCalendar.currentCalendar()

        let dateParts = calendar.components([NSCalendarUnit.Hour, NSCalendarUnit.Minute], fromDate: today)
        print(today.convertToString())

        dateParts.month = SettingsHelper.expirMonth
        dateParts.day = SettingsHelper.expirDay
        dateParts.year = SettingsHelper.expirYear
        dateParts.hour = SettingsHelper.datePickerHour
        dateParts.minute = SettingsHelper.datePickerMin
        //  dateParts.day = dateParts.day - day

        print(dateParts)
        let dateAtTheTime = calendar.dateFromComponents(dateParts)
        print(dateAtTheTime?.convertToString())      //NOT WORKING SETTING TO DEC 29
        return dateAtTheTime!
    }

    func makeNotification(nsdate: NSDate) {
        var category: String?

        let notification = notificationFacade.buildNotificationWithDate(nsdate, timeZone: false, category: category, userInfo: nil)
        notificationFacade.customizeNotificationAlert(notification, title: noteNameTextField.text, body: "eat by" + noteDateTextField.text!, action: "accept", launchImage: nil)
        // show error alert if needed
        do {
            try notificationFacade.canScheduleNotification(notification, withRecovery: false)
        }
        catch {
            let alert = notificationFacade.buildAlertControlForError(error as NSError)
            notificationFacade.showAlertController(alert)
        }
        // schedule notification if possible
        do {
            try notificationFacade.scheduleNotification(notification)
            navigationController?.popViewControllerAnimated(true)
        }
        catch {

        }
    }



    @IBAction func typedName(sender: AnyObject) {
        itemNameLabel.text = noteNameTextField.text
    }

    @IBAction func typedDate(sender: AnyObject) {
        daysLeftLabel.text = noteDateTextField.text

        let indexOne: String.Index = (daysLeftLabel.text?.startIndex.advancedBy(2))!
        var month = daysLeftLabel.text?.substringToIndex(indexOne)
        SettingsHelper.expirMonth = Int(month!)!
        print("\nMONTH " + month!)

        let indexTwo: String.Index = (daysLeftLabel.text?.startIndex.advancedBy(2))!
        var day = daysLeftLabel.text?.substringFromIndex(indexOne).substringToIndex(indexTwo)
        SettingsHelper.expirDay = Int(day!)!
        print("\nDAY " + day!)

        let indexThree: String.Index = (daysLeftLabel.text?.endIndex)!
        var year = daysLeftLabel.text?.substringFromIndex(indexTwo)
        //YEAR NOT ASSIGNING PROPERLY
        year = "2016"
        SettingsHelper.expirYear = Int(year!)!
        print("\nYEAR " + year!)
    }

    @IBAction func CameraTwoAction(sender: UIButton) {
        // let picker = UIImagePickerController()
        // picker.delegate = self
        picker.sourceType = .Camera
        presentViewController(picker, animated: true, completion: nil)

    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let selectedPhoto = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageDisplay.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        let scaledImage = scaleImage(selectedPhoto, maxDimension: 640)
        addActivityIndicator()
        dismissViewControllerAnimated(true, completion: {
            self.performImageRecognition(scaledImage)
        })
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("reached prepareForSegue")
        if segue.identifier != "Camera" && segue.identifier != "CameraTwo"
        {
            let listNotesTableViewController = segue.destinationViewController as! GroceryListViewController //error: WHY IS IT COMING HERE??
            if segue.identifier == "Save" {
                // if note exists, update title and content
                if let note = note {
                    // 1
                    let newNote = GroceryItem()
                    newNote.itemName = noteNameTextField.text ?? ""

                    newNote.daysLeft = Int(noteDateTextField.text!) ?? 0  //Convert String to int
                    RealmHelper.updateNote(note, newNote: newNote)
                } else {
                    // if note does not exist, create new note
                    let note = GroceryItem()
                    note.itemName = noteNameTextField.text ?? ""
                    note.daysLeft = Int(noteDateTextField.text!) ?? 0 //Convert String to int

                    //adds notification

                    if notificationCheckbox.isChecked
                    {

                        print("notifs checkbox clicked")
                        var notifDate = NSDate()

                        print(SettingsHelper.datePickerTime.convertToString())
                        print(SettingsHelper.datePickerHour)
                        print(SettingsHelper.datePickerMin)

                        print("that day clicked")
                        notifDate = initializeDateWithTime(dateFromDatePicker, hrs: SettingsHelper.datePickerHour, minutes: SettingsHelper.datePickerMin, day: 1)
                        print(notifDate.convertToString())
                        makeNotification(notifDate)
                        print("notification sent")

                        /*   if !settingsViewController.oneDayCheckbox.isChecked
                         {
                         print("one day clicked")
                         notifDate = initializeDateWithTime(dateFromDatePicker, hrs: SettingsHelper.datePickerHour, minutes: SettingsHelper.datePickerMin, day: 1)
                         print(notifDate)
                         makeNotification(notifDate)
                         print("notification sent")
                         }

                         */
                        /*
                         if SettingsViewController().twoDaysCheckbox.isChecked
                         {
                         notifDate = initializeDateWithTime(dateFromDatePicker, hrs: SettingsHelper.datePickerHour, minutes: SettingsHelper.datePickerMin, day: 2)
                         makeNotification(notifDate)
                         }
                         if SettingsViewController().threeDaysCheckbox.isChecked
                         {
                         notifDate = initializeDateWithTime(dateFromDatePicker, hrs: SettingsHelper.datePickerHour, minutes: SettingsHelper.datePickerMin, day: 3)
                         makeNotification(notifDate)
                         }
                         */
                    }

                    //  note.modificationTime = NSDate()
                    RealmHelper.addNote(note)
                }
                listNotesTableViewController.notes = RealmHelper.retrieveNotes()
            }
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let note = note {
            noteNameTextField.text = note.itemName
            noteDateTextField.text = String(note.daysLeft)

        } else {
            noteNameTextField.text = ""
            noteDateTextField.text = ""
        }
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }


    func scaleImage(image: UIImage, maxDimension: CGFloat) -> UIImage {

        var scaledSize = CGSizeMake(maxDimension, maxDimension)
        var scaleFactor:CGFloat

        if image.size.width > image.size.height {
            scaleFactor = image.size.height / image.size.width
            scaledSize.width = maxDimension
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            scaleFactor = image.size.width / image.size.height
            scaledSize.height = maxDimension
            scaledSize.width = scaledSize.height * scaleFactor
        }

        UIGraphicsBeginImageContext(scaledSize)
        image.drawInRect(CGRectMake(0, 0, scaledSize.width, scaledSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return scaledImage
    }

    // Activity Indicator methods

    func addActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: view.bounds)
        activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.25)
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }

    func removeActivityIndicator() {
        activityIndicator.removeFromSuperview()
        activityIndicator = nil
    }


    // The remaining methods handle the keyboard resignation/
    // move the view so that the first responders aren't hidden


    func storeLanguageFile() {
        print("sdf")
        let fileManager: NSFileManager = NSFileManager.defaultManager()
        let docsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let path = NSURL(fileURLWithPath: docsDirectory).URLByAppendingPathComponent("/tessdata/eng.traineddata").absoluteString
        if !fileManager.fileExistsAtPath(path) {
            let data = NSData(contentsOfFile: NSBundle.mainBundle().resourcePath!.stringByAppendingString("/tessdata/eng.traineddata"))!
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(NSURL(fileURLWithPath: docsDirectory).URLByAppendingPathComponent("/tessdata").absoluteString, withIntermediateDirectories: true, attributes: nil)
            }
            catch { }
            data.writeToFile(path, atomically: true)
        }
    }
    
    
    func performImageRecognition(image: UIImage) {
        
        let tesseract = G8Tesseract()
        
        tesseract.language = "eng+fra"
        
        tesseract.engineMode = .TesseractCubeCombined
        
        tesseract.pageSegmentationMode = .Auto
        
        tesseract.maximumRecognitionTime = 60.0
        
        tesseract.image = image.g8_blackAndWhite()
        tesseract.recognize()
        
        textView.text = tesseract.recognizedText
        print(tesseract.recognizedText)
        textView.editable = true
        
        removeActivityIndicator()
    }
    
    
    func imagePickerController(didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let selectedPhoto = info[UIImagePickerControllerOriginalImage] as! UIImage
        let scaledImage = scaleImage(selectedPhoto, maxDimension: 640)
        addActivityIndicator()
        dismissViewControllerAnimated(true, completion: {
            self.storeLanguageFile()
            print("d")
            self.performImageRecognition(scaledImage)
        })
    }
}

