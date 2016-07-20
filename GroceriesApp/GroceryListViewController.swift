
import UIKit
import RealmSwift

class GroceryListViewController: UITableViewController {

   var notes: Results<GroceryItem>!{
      didSet {
         tableView.reloadData()
      }
   }


   override func viewDidLoad() {
      super.viewDidLoad()
      notes = RealmHelper.retrieveNotes()
   }


   override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return notes.count
   }

   override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

      let cell = tableView.dequeueReusableCellWithIdentifier("listGroceryCell", forIndexPath: indexPath) as! ListGroceryCell

      let row = indexPath.row

      let note = notes[row]

      cell.noteTitleLabel.text = note.itemName

      cell.noteDaysLeft.text = String(note.daysLeft)
      //  cell.noteModificationTimeLabel.text = note.modificationTime.convertToString()
      
      return cell
   }


   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if let identifier = segue.identifier {
         if identifier == "displayNote" {
            print("Table view cell tapped")

            // 1
            let indexPath = tableView.indexPathForSelectedRow!
            // 2
            let note = notes[indexPath.row]
            // 3
            let displayNoteViewController = segue.destinationViewController as! PhotoViewController
            // 4
            displayNoteViewController.note = note

         } else if identifier == "addNote" {
            print("+ button tapped")
         } else if identifier == "Settings" {
            print("Settings")
         }
      }
   }

   @IBAction func unwindToListNotesViewController(segue: UIStoryboardSegue) {

      // for now, simply defining the method is sufficient.
      // we'll add code later

   }


   // 1
   override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
      if editingStyle == .Delete {
         //1
         RealmHelper.deleteNote(notes[indexPath.row])
         //2
         notes = RealmHelper.retrieveNotes()
      }
   }
}


