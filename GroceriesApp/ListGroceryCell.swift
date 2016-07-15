//
//  ListGroceryCell.swift
//  GroceriesApp
//
//  Created by Jananni Rathnagiri on 7/13/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import UIKit

class ListGroceryCell: UITableViewCell {

   @IBOutlet weak var noteTitleLabel: UILabel!
   @IBOutlet weak var noteDaysLeft: UILabel!

   var groceryItem: GroceryItem? {
      didSet {
         if let groceryItem = groceryItem
         {
            noteTitleLabel.text = groceryItem.itemName
            noteDaysLeft.text = String(groceryItem.daysLeft)
         }
      }
   }

}
