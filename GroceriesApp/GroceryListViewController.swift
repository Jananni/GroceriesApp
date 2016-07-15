//
//  GroceryListViewController.swift
//  GroceriesApp
//
//  Created by Jananni Rathnagiri on 7/15/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import UIKit

class GroceryListViewController: UIViewController {

   @IBOutlet weak var tableView: UITableView!
   var groceries: [GroceryItem]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension GroceryListViewController: UITableViewDataSource {

   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return groceries?.count ?? 0
   }

   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier("ListGroceryCell") as! ListGroceryCell
      cell.groceryItem = groceries![indexPath.row]
      return cell
   }

}