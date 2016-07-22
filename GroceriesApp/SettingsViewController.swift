//
//  SettingsViewController.swift
//  GroceriesApp
//
//  Created by Jananni Rathnagiri on 7/20/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import UIKit
import MobileCoreServices
import RealmSwift

class SettingsViewController: UIViewController {

   var setting: Settings?

   @IBOutlet weak var notifsCheckbox: CheckBox!
   @IBOutlet weak var thatDayCheckbox: CheckBox!
   @IBOutlet weak var oneDayCheckbox: CheckBox!
   @IBOutlet weak var twoDaysCheckbox: CheckBox!
   @IBOutlet weak var threeDaysCheckbox: CheckBox!


   override func viewDidLoad() {
      super.viewDidLoad()
      setting = RealmHelper.retrieveSettings().last

      notifsCheckbox.isChecked = (setting?.notifications)!
      thatDayCheckbox.isChecked = (setting?.thatDay)!
      oneDayCheckbox.isChecked = (setting?.oneDay)!
      twoDaysCheckbox.isChecked = (setting?.twoDays)!
      threeDaysCheckbox.isChecked = (setting?.threeDays)!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      let listNotesTableViewController = segue.sourceViewController as! SettingsViewController // error
      if segue.identifier == "SaveSettings" {
         // if note exists, update title and content
         if let setting = setting {
            // 1
            let newSetting = Settings()
            newSetting.notifications = notifsCheckbox.isChecked ?? false
            newSetting.thatDay = thatDayCheckbox.isChecked ?? false
            newSetting.oneDay = oneDayCheckbox.isChecked ?? false
            newSetting.twoDays = twoDaysCheckbox.isChecked ?? false
            newSetting.threeDays = threeDaysCheckbox.isChecked ?? false
            RealmHelper.updateSettings(setting, newSettings: newSetting)
         }
         else
         {
            let setting = Settings()
            setting.notifications = notifsCheckbox.isChecked ?? false
            setting.thatDay = thatDayCheckbox.isChecked ?? false
            setting.oneDay = oneDayCheckbox.isChecked ?? false
            setting.twoDays = twoDaysCheckbox.isChecked ?? false
            setting.threeDays = threeDaysCheckbox.isChecked ?? false
            notifsCheckbox.isChecked = setting.notifications
            RealmHelper.addSettings(setting)
         }
         let temp: Results<Settings> = RealmHelper.retrieveSettings()
         listNotesTableViewController.setting = temp.last
      }
   }

}
