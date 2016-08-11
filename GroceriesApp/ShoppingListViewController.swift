//
//  ShoppingListViewController.swift
//  GroceriesApp
//
//  Created by Jananni Rathnagiri on 8/8/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import UIKit
import RealmSwift

class ShoppingListViewController: UIViewController {

    @IBOutlet weak var shoppingTableView: UITableView!

    var shoppingList: Results<ShoppingItem>!{
        didSet {                                                                                                                                                                                    
            shoppingTableView.reloadData()
            //       print(shoppingList)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        shoppingList = RealmHelper.retrieveShoppingItem()
        //  print(shoppingList)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("listShoppingCell", forIndexPath: indexPath) as! ShoppingListCell
        let row = indexPath.row
        let note = shoppingList[row]
        cell.shoppingItemLabel.text = note.shoppingItemName

        return cell
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            //1
            RealmHelper.deleteShoppingItem(shoppingList[indexPath.row])
            //2
            shoppingList = RealmHelper.retrieveShoppingItem()
        }
/*
        let cell = tableView.dequeueReusableCellWithIdentifier("listShoppingCell", forIndexPath: indexPath) as! ShoppingListCell

        if cell.shouldDelete {

            RealmHelper.deleteShoppingItem(shoppingList[indexPath.row])
            //2
            shoppingList = RealmHelper.retrieveShoppingItem()
        }
 */
    }




    /*

     =['// MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
