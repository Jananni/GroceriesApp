//
//  Settings.swift
//  GroceriesApp
//
//  Created by Jananni Rathnagiri on 7/20/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import Foundation

import RealmSwift


class Settings: Object {

    dynamic var notifications: Bool = false
    dynamic var thatDay: Bool = false
    dynamic var oneDay: Bool = false
    dynamic var twoDays: Bool = false
    dynamic var threeDays: Bool = false

    
    
}