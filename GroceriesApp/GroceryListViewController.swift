
import UIKit
import RealmSwift


class GroceryListViewController: UITableViewController, KCFloatingActionButtonDelegate{


    var fab = KCFloatingActionButton()

    var notes: Results<GroceryItem>!{
        didSet {
            tableView.reloadData()
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        notes = RealmHelper.retrieveNotes()
        if !UIApplication.sharedApplication().isRegisteredForRemoteNotifications(){
            let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Sound, .Badge], categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        }
        layoutFAB()
    }

    @IBAction func endEditing() {
        view.endEditing(true)
    }

    @IBAction func customImageSwitched(sender: UISwitch) {
        if sender.on == true {
            fab.buttonImage = UIImage(named: "custom-add")
        } else {
            fab.buttonImage = nil
        }
    }

    func layoutFAB() {
        let item = KCFloatingActionButtonItem()
        item.buttonColor = UIColor.blueColor()
        item.circleShadowColor = UIColor.redColor()
        item.titleShadowColor = UIColor.blueColor()
        item.title = "Custom item"
        item.handler = { item in

        }

        fab.addItem(title: "I got a title")
        fab.addItem("I got a icon", icon: UIImage(named: "icShare"))
        fab.addItem("I got a handler", icon: UIImage(named: "icMap")) { item in
            let alert = UIAlertController(title: "Hey", message: "I'm hungry...", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Me too", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            self.fab.close()
        }
        fab.addItem(item: item)
        fab.fabDelegate = self

        self.view.addSubview(fab)

    }

    func KCFABOpened(fab: KCFloatingActionButton) {
        print("FAB Opened")
    }

    func KCFABClosed(fab: KCFloatingActionButton) {
        print("FAB Closed")
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

        if Int(cell.noteDaysLeft.text!)! <= 3
        {
            let swiftColor = UIColor(red: 255/255, green: 204/255, blue: 103/255, alpha: 1)
            cell.noteTitleLabel.backgroundColor = swiftColor
            cell.backgroundColor = swiftColor
        }
        else if Int(cell.noteDaysLeft.text!)! <= 7
        {
            let swiftColortwo = UIColor(red: 255/255, green: 255/255, blue: 204/255, alpha: 1)
            cell.noteTitleLabel.backgroundColor = swiftColortwo
            cell.backgroundColor = swiftColortwo
        }
        else
        {
            let swiftColorthree = UIColor(red: 204/255, green: 255/255, blue: 204/255, alpha: 1)
            cell.noteTitleLabel.backgroundColor = swiftColorthree
            cell.backgroundColor = swiftColorthree
        }

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


