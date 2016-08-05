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
//import SwiftValidators

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var CameraTwo: UIButton!
    @IBOutlet weak var imageDisplay: UIImageView!
    @IBOutlet weak var noteNameTextField: UITextField!
    @IBOutlet weak var noteDateTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var notificationCheckbox: CheckBox!
    //   @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var instructionLabel: UILabel!

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
        // saveBarButton.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Arial", size: 15)!], forState: UIControlState.Normal)
        picker.delegate = self
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
/*
        noteNameTextField.text = SettingsHelper.itemName
        noteDateTextField.text = SettingsHelper.itemDaysLeft
 */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initializeDateWithTime(date:NSDate,hrs:Int,minutes:Int, day:Int) -> NSDate{
        let today = date
        let calendar:NSCalendar = NSCalendar.currentCalendar()

        let dateParts = calendar.components([NSCalendarUnit.Hour, NSCalendarUnit.Minute], fromDate: today)

        dateParts.month = SettingsHelper.expirMonth
        //    dateParts.day = SettingsHelper.expirDay
        dateParts.year = SettingsHelper.expirYear
        dateParts.hour = SettingsHelper.datePickerHour
        dateParts.minute = SettingsHelper.datePickerMin
        dateParts.day = SettingsHelper.expirDay - day

        let dateAtTheTime = calendar.dateFromComponents(dateParts)
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
        SettingsHelper.itemName = noteNameTextField.text!
    }

    @IBAction func typedDate(sender: UITextField) {
        SettingsHelper.itemDaysLeft = noteDateTextField.text!
        var daysLeftLabel = SettingsHelper.itemDaysLeft

        if(daysLeftLabel != "" && daysLeftLabel.characters.count == 8)
        {

            let indexOne: String.Index = (daysLeftLabel.startIndex.advancedBy(2))
            var month = daysLeftLabel.substringToIndex(indexOne)
            SettingsHelper.expirMonth = Int(month)!
            print("\nMONTH " + month)

            let indexTwo: String.Index = (daysLeftLabel.startIndex.advancedBy(2))
            var day = daysLeftLabel.substringFromIndex(indexOne.advancedBy(1)).substringToIndex(indexTwo)
            SettingsHelper.expirDay = Int(day)!
            print("\nDAY " + day)

            let indexThree: String.Index = (daysLeftLabel.startIndex.advancedBy(2))
            var year = daysLeftLabel.substringFromIndex(indexTwo.advancedBy(1))
            //YEAR NOT ASSIGNING PROPERLY
            year = "2016"
            SettingsHelper.expirYear = Int(year)!
        }
        else
        {
            //make an alert

            let alertController = UIAlertController(title: "Expiration Date Format", message:
                "Please enter a string following the given format", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))

            self.presentViewController(alertController, animated: true, completion: nil)
            noteDateTextField.text = ""

        }
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

        instructionLabel.text = ""
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("reached prepareForSegue")
        if segue.identifier != "Camera" && segue.identifier != "CameraTwo"
        {
            let listNotesTableViewController = segue.destinationViewController as! GroceryListViewController //error: WHY IS IT COMING HERE??
            if ((segue.identifier == "Save" && noteNameTextField.text != "") && noteDateTextField.text != ""){
                // if note exists, update title and content
                print("saveItem")
                if let note = note {
                    // 1
                    let newNote = GroceryItem()
                    newNote.itemName = noteNameTextField.text ?? ""

                    //  newNote.daysLeft = Int(noteDateTextField.text!) ?? 0  //Convert String to int
                    newNote.daysLeft = Int(SettingsHelper.expirDate.timeIntervalSinceNow)  //today how to calculat

                    RealmHelper.updateNote(note, newNote: newNote)
                } else {
                    // if note does not exist, create new note
                    let note = GroceryItem()
                    note.itemName = noteNameTextField.text ?? ""

                    //adds notification

                    if notificationCheckbox.isChecked
                    {
                        calculateWithNotifications(note)
                    }
                    else
                    {
                        calculateWithoutNotifications(note)
                    }
                    //  note.modificationTime = NSDate()
                    RealmHelper.addNote(note)
                }

                listNotesTableViewController.notes = RealmHelper.retrieveNotes()
            }
                /*
            else if noteNameTextField.text == ""
            {
                let alertController = UIAlertController(title: "Item Name Field", message:
                    "Please enter a string for the item name", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))

                self.presentViewController(alertController, animated: true, completion: nil)
            }
            else if noteDateTextField.text == ""
            {
                let alertController = UIAlertController(title: "Expiration Date Field", message:
                    "Please enter a date for the expiration date", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))

                self.presentViewController(alertController, animated: true, completion: nil)
            }
 */
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

    func storeLanguageFile() {
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
        noteDateTextField.text = tesseract.recognizedText
        print(tesseract.recognizedText)
        print(tesseract.recognizedText)
        removeActivityIndicator()
    }

    func imagePickerController(didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let selectedPhoto = info[UIImagePickerControllerOriginalImage] as! UIImage
        let scaledImage = scaleImage(selectedPhoto, maxDimension: 640)
        addActivityIndicator()
        dismissViewControllerAnimated(true, completion: {
            self.storeLanguageFile()
            self.performImageRecognition(scaledImage)
        })
    }

    func calculateDaysBetweenDates(startDate: NSDate, endDate: NSDate) -> Int
    {
        let calendarTwo = NSCalendar.currentCalendar()
        let components = calendarTwo.components([.Day], fromDate: startDate, toDate: endDate, options: [])
        return components.day

    }

    func calculateWithNotifications(note: GroceryItem)
    {
        SettingsHelper.expirDate = initializeDateWithTime(dateFromDatePicker, hrs: SettingsHelper.datePickerHour, minutes: SettingsHelper.datePickerMin, day: 0)
        makeNotification(SettingsHelper.expirDate)
        note.daysLeft = calculateDaysBetweenDates(NSDate(), endDate: SettingsHelper.expirDate)

        if RealmHelper.retrieveSettings().first?.oneDay == true
        {
            SettingsHelper.expirDate = initializeDateWithTime(dateFromDatePicker, hrs: SettingsHelper.datePickerHour, minutes: SettingsHelper.datePickerMin, day: 1)
            makeNotification(SettingsHelper.expirDate)
        }


        if RealmHelper.retrieveSettings().first?.twoDays == true
        {
            SettingsHelper.expirDate = initializeDateWithTime(dateFromDatePicker, hrs: SettingsHelper.datePickerHour, minutes: SettingsHelper.datePickerMin, day: 2)
            makeNotification(SettingsHelper.expirDate)
        }
        if RealmHelper.retrieveSettings().first?.threeDays == true
        {
            SettingsHelper.expirDate = initializeDateWithTime(dateFromDatePicker, hrs: SettingsHelper.datePickerHour, minutes: SettingsHelper.datePickerMin, day: 3)
            makeNotification(SettingsHelper.expirDate)
        }
    }

    func calculateWithoutNotifications(note: GroceryItem)
    {
        SettingsHelper.expirDate = initializeDateWithTime(dateFromDatePicker, hrs: SettingsHelper.datePickerHour, minutes: SettingsHelper.datePickerMin, day: 0)
        //   makeNotification(SettingsHelper.expirDate)
        note.daysLeft = calculateDaysBetweenDates(NSDate(), endDate: SettingsHelper.expirDate)

        if RealmHelper.retrieveSettings().first?.oneDay == true
        {
            SettingsHelper.expirDate = initializeDateWithTime(dateFromDatePicker, hrs: SettingsHelper.datePickerHour, minutes: SettingsHelper.datePickerMin, day: 1)
            //   makeNotification(SettingsHelper.expirDate)
        }


        if RealmHelper.retrieveSettings().first?.twoDays == true
        {
            SettingsHelper.expirDate = initializeDateWithTime(dateFromDatePicker, hrs: SettingsHelper.datePickerHour, minutes: SettingsHelper.datePickerMin, day: 2)
            //    makeNotification(SettingsHelper.expirDate)
        }
        if RealmHelper.retrieveSettings().first?.threeDays == true
        {
            SettingsHelper.expirDate = initializeDateWithTime(dateFromDatePicker, hrs: SettingsHelper.datePickerHour, minutes: SettingsHelper.datePickerMin, day: 3)
            //   makeNotification(SettingsHelper.expirDate)
        }
    }
}









