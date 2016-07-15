//
//  GroceryItem.swift
//  GroceriesApp
//
//  Created by Jananni Rathnagiri on 7/14/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import Foundation

import RealmSwift


class GroceryItem: Object {
/*   var daysLeft: Int
   var itemName: String

   init (days: Int, name: String) {
      self.daysLeft = days
      self.itemName = name
   }
*/
   dynamic var daysLeft: Int = 0
   dynamic var itemName: String = ""



}