//
//  DisplayNoteViewController.swift
//  MakeSchoolNotes
//
//  Created by Chris Orcutt on 1/10/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//


/*

import UIKit
import RealmSwift

class DisplayItemViewController: UIViewController {

   @IBOutlet weak var noteContentTextView: UITextView!
   @IBOutlet weak var noteDaysLeftTextField: UITextField!

   var note: GroceryItem?

   override func viewDidLoad() {
      super.viewDidLoad()
   }

   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      let listNotesTableViewController = segue.destinationViewController as! GroceryListTableControllerTableViewController
      if segue.identifier == "Save" {
         // if note exists, update title and content
         if let note = note {
            // 1
            let newNote = GroceryItem()
            newNote.daysLeft = noteDaysLeftTextField.text ?? ""
            newNote.content = noteContentTextView.text ?? ""
            RealmHelper.updateNote(note, newNote: newNote)
         } else {
            // if note does not exist, create new note
            let note = GroceryItem()
            note.daysLeft = noteDaysLeftTextField.text ?? ""
            note.content = noteContentTextView.text ?? ""
            note.modificationTime = NSDate()
            // 2
            RealmHelper.addNote(note)
         }
         // 3
         listNotesTableViewController.notes = RealmHelper.retrieveNotes()
      }
   }

   override func viewWillAppear(animated: Bool) {
      super.viewWillAppear(animated)
      // 1
      if let note = note {
         // 2
         noteDaysLeftTextField.text = note.daysLeft
         noteContentTextView.text = note.content
      } else {
         // 3
         noteDaysLeftTextField.text = ""
         noteContentTextView.text = ""
      }
   }
   
}
 
 */
