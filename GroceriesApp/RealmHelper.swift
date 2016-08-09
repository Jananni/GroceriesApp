//
//  RealmHelper.swift
//  MakeSchoolNotes
//
//  Created by Jananni Rathnagiri on 6/23/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import Foundation
import RealmSwift

class RealmHelper {
    //static methods will go here

    static func addNote(note: GroceryItem) {
        let realm = try! Realm()
        try! realm.write() {
            realm.add(note)
        }
    }

    static func deleteNote(note: GroceryItem) {
        let realm = try! Realm()
        try! realm.write() {
            realm.delete(note)
        }
    }

    static func updateNote(noteToBeUpdated: GroceryItem, newNote: GroceryItem) {
        let realm = try! Realm()
        try! realm.write() {
            noteToBeUpdated.itemName = newNote.itemName
            noteToBeUpdated.daysLeft = newNote.daysLeft
            //   noteToBeUpdated.content = newNote.content
            //     noteToBeUpdated.modificationTime = newNote.modificationTime
        }
    }

    static func retrieveNotes() -> Results<GroceryItem> {
        let realm = try! Realm()
        return realm.objects(GroceryItem).sorted("daysLeft", ascending: true)
    }

    static func retrieveSettings() -> Results<Settings>{
        let realm = try! Realm()
        return realm.objects(Settings)
    }

    static func addSettings(setting: Settings) {
        let realm = try! Realm()
        try! realm.write() {
            realm.add(setting)
        }
    }

    static func updateSettings(settingsToBeUpdated: Settings, newSettings: Settings) {
        let realm = try! Realm()
        try! realm.write() {
            //    settingsToBeUpdated.notifications = newSettings.notifications
            settingsToBeUpdated.thatDay = newSettings.thatDay
            settingsToBeUpdated.oneDay = newSettings.oneDay
            settingsToBeUpdated.twoDays = newSettings.twoDays
            settingsToBeUpdated.threeDays = newSettings.threeDays
        }
        
    }


    static func addShoppingItem(shoppingItem: ShoppingItem) {
        print("in realnhelper")
        let realm = try! Realm()
        try! realm.write() {
            realm.add(shoppingItem)
            print(shoppingItem)
        }
    }

    static func deleteShoppingItem(shoppingItem: ShoppingItem) {
        let realm = try! Realm()
        try! realm.write() {
            realm.delete(shoppingItem)
        }
    }

    static func updateShoppingItem(itemToBeUpdated: ShoppingItem, newShoppingItem: ShoppingItem) {
        let realm = try! Realm()
        try! realm.write() {
            itemToBeUpdated.shoppingItemName = newShoppingItem.shoppingItemName

        }
    }

    static func retrieveShoppingItem() -> Results<ShoppingItem> {
        let realm = try! Realm()
        return realm.objects(ShoppingItem).sorted("shoppingItemName", ascending: true)
    }
    
}

