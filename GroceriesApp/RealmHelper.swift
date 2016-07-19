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

   static func doSomething() {

   }

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
         //   noteToBeUpdated.content = newNote.content
         //     noteToBeUpdated.modificationTime = newNote.modificationTime
      }
   }

   static func retrieveNotes() -> Results<GroceryItem> {
      let realm = try! Realm()
      return realm.objects(GroceryItem).sorted("itemName", ascending: false)
   }
   
}

