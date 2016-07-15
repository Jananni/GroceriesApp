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


   @IBOutlet weak var Camera: UIButton!
   @IBOutlet weak var Cameratwo: UIButton!

   @IBOutlet weak var ImageDisplay: UIImageView!

   @IBOutlet weak var noteNameTextField: UITextField!

   @IBOutlet weak var noteDateTextField: UITextField!

   var note: GroceryItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



   @IBAction func CameraAction(sender: UIButton) {
      let picker = UIImagePickerController()
      picker.delegate = self
      picker.sourceType = .Camera
      presentViewController(picker, animated: true, completion: nil)

   }

   @IBAction func CameratwoAction(sender: AnyObject) {

      let picker = UIImagePickerController()
      picker.delegate = self
      picker.sourceType = .Camera
      presentViewController(picker, animated: true, completion: nil)


   }



   func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
      ImageDisplay.image = info[UIImagePickerControllerOriginalImage] as? UIImage; dismissViewControllerAnimated(true, completion: nil)
   }



   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      let listNotesTableViewController = segue.destinationViewController as! GroceryListViewController
      if segue.identifier == "Save" {
         // if note exists, update title and content
         if let note = note {
            // 1
            let newNote = GroceryItem()
            //       newNote.daysLeft = NSDate() - noteDateTextField.date ?? ""
            newNote.itemName = noteNameTextField.text ?? ""
            RealmHelper.updateNote(note, newNote: newNote)
         } else {
            // if note does not exist, create new note
            let note = GroceryItem()
            //       note.daysLeft = NSDate() - noteDateTextField.date ?? ""
            note.itemName = noteNameTextField.text ?? ""
            // 2
            RealmHelper.addNote(note)
         }
         // 3
         //    listNotesTableViewController.groceries = RealmHelper.retrieveNotes()
      }
   }

   override func viewWillAppear(animated: Bool) {
      super.viewWillAppear(animated)
//      // 1
//      if let note = note {
//         // 2
//         noteDateTextField.text = note.daysLeft
//         noteNameTextField.text = note.itemName
//      } else {
//         // 3
//         noteDateTextField.text = ""
//         noteNameTextField.text = ""
//      }
   }


}
