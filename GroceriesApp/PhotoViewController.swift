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

   @IBOutlet weak var imageDisplay: UIImageView!

   @IBOutlet weak var noteNameTextField: UITextField!

   @IBOutlet weak var noteDateTextField: UITextField!

   @IBOutlet weak var saveButton: UIBarButtonItem!

   @IBOutlet weak var notificationCheckbox: CheckBox!

   @IBOutlet weak var datePicker: UIDatePicker!

   let notificationFacade = MRLocalNotificationFacade.defaultInstance()

   let expDateAsNSDateComponents = NSDateComponents()



   var note: GroceryItem?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


   @IBAction func CameraTwoAction(sender: UIButton) {
      let picker = UIImagePickerController()
      picker.delegate = self
      picker.sourceType = .Camera
      presentViewController(picker, animated: true, completion: nil)


   }

   func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
      imageDisplay.image = info[UIImagePickerControllerOriginalImage] as? UIImage; dismissViewControllerAnimated(true, completion: nil)
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


               //      expDateAsNSDateComponents.day =

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

                  var category: String?

                  let notification = notificationFacade.buildNotificationWithDate(datePicker.date, timeZone: false, category: category, userInfo: nil)
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

 /*  func disectDate() -> [Int]
   {
      var fullDateInput = noteDateTextField.text
      var month = fullDateInput.
   }
 */

}
