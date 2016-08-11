//
//  ShoppingItem.swift
//  GroceriesApp
//
//  Created by Jananni Rathnagiri on 8/8/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import Foundation

import RealmSwift
import Realm

class ShoppingItem: Object {

    dynamic var shoppingItemName: String = ""

    required init() {
        super.init()
    }
    init(bar: String) {
        self.shoppingItemName = bar
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: AnyObject, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }

    override func isEqual(object: AnyObject?) -> Bool {
        if let object = object as? ShoppingItem {
            return object.shoppingItemName == self.shoppingItemName
        } else  {
            return false
        }
    }
}