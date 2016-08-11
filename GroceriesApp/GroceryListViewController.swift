
import UIKit
import RealmSwift


class GroceryListViewController: UIViewController, KCFloatingActionButtonDelegate{

    @IBOutlet weak var tableView: UITableView!


    var shoppingListItem: String = ""


    var fab = KCFloatingActionButton()

    var shoppingButtonClickedAlready: Bool = false

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
            fab.buttonImage = UIImage(named: "edit_property")   //change Image
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

        fab.addItem("Shopping List", icon: UIImage(named: "shopping_cart")) { item in
            self.performSegueWithIdentifier("gotoAddFromPlaylist", sender: self)
            self.fab.close()
        }
        fab.fabDelegate = self

        self.view.addSubview(fab)

    }

    func KCFABOpened(fab: KCFloatingActionButton) {
        print("FAB Opened")
    }

    func KCFABClosed(fab: KCFloatingActionButton) {
        print("FAB Closed")
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("listGroceryCell", forIndexPath: indexPath) as! ListGroceryCell
        let row = indexPath.row
        let note = notes[row]
        cell.delegate = self
        cell.noteTitleLabel.text = note.itemName
        cell.noteDaysLeft.text = String(note.daysLeft)

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
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            //1
            RealmHelper.deleteNote(notes[indexPath.row])
            //2
            notes = RealmHelper.retrieveNotes()
        }
    }
}

extension GroceryListViewController: ListGroceryCellDelegate
{
    func buttonCellClicked(cell: ListGroceryCell)
    {
        /*
        if !shoppingButtonClickedAlready
        {
            //   shoppingListItem = cell.noteTitleLabel.text!
            var isSomethingThereAlready = false

            for i in 0...RealmHelper.retrieveShoppingItem().count
            {
                print("COUNT")
                print(RealmHelper.retrieveShoppingItem().count)
                if cell.noteTitleLabel.text! == RealmHelper.retrieveNotes()[i]
                {
                    isSomethingThereAlready = true
                }
            }
            if !isSomethingThereAlready
            {
                shoppingListItem = cell.noteTitleLabel.text!
                RealmHelper.addShoppingItem(ShoppingItem(bar: cell.noteTitleLabel.text!))
                shoppingButtonClickedAlready = !shoppingButtonClickedAlready
            }
        }
        else
        {
            RealmHelper.deleteShoppingItem(ShoppingItem(bar: cell.noteTitleLabel.text!))
            shoppingButtonClickedAlready = !shoppingButtonClickedAlready
        }
 */
        shoppingButtonClickedAlready = cell.shoppingClicked
        if !shoppingButtonClickedAlready
        {
            let shoppingSet = Set(RealmHelper.retrieveShoppingItem())


            shoppingListItem = cell.noteTitleLabel.text!
            let newShoppingItem = ShoppingItem(bar: shoppingListItem)

            print(shoppingSet.contains(newShoppingItem))
            if !shoppingSet.contains(newShoppingItem)
            {
                RealmHelper.addShoppingItem(ShoppingItem(bar: cell.noteTitleLabel.text!))
                cell.shoppingClicked = !cell.shoppingClicked
            }
            else
            {
                cell.shoppingClicked = !cell.shoppingClicked
            }
        }
        else
        {
            //     cell.shouldDelete = !cell.shouldDelete
            cell.shoppingClicked = !cell.shoppingClicked
        }

        // RealmHelper.addShoppingItem(ShoppingItem(bar: cell.noteTitleLabel.text!))
    }
}

