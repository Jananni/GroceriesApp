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

   /*
   var setting: Settings?{
      didSet {
         viewDidLoad()
      }
   }
 */
   var setting: Settings?

   @IBOutlet weak var notifsCheckbox: CheckBox!
   @IBOutlet weak var thatDayCheckbox: CheckBox!
   @IBOutlet weak var oneDayCheckbox: CheckBox!
   @IBOutlet weak var twoDaysCheckbox: CheckBox!
   @IBOutlet weak var threeDaysCheckbox: CheckBox!


   override func viewDidLoad() {
      super.viewDidLoad()
      setting = RealmHelper.retrieveSettings().last
      //    setting?.notifications = false
      // setting?.oneDay = false
      // setting?.twoDays = false
      // setting?.threeDays = false
      //maybe???? idk hopefully kinda
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      let listNotesTableViewController = segue.sourceViewController as! SettingsViewController // error
      if segue.identifier == "SaveSettings" {
         // if note exists, update title and content
         print("bl")
         if let setting = setting {
            // 1
            let newSetting = Settings()
            newSetting.notifications = notifsCheckbox.isChecked ?? false
            newSetting.thatDay = thatDayCheckbox.isChecked ?? false
            newSetting.oneDay = oneDayCheckbox.isChecked ?? false
            newSetting.twoDays = twoDaysCheckbox.isChecked ?? false
            newSetting.threeDays = threeDaysCheckbox.isChecked ?? false
            RealmHelper.saveSettings(setting, newSettings: newSetting)
            print(newSetting.notifications)
            print(newSetting.thatDay)
            print(newSetting.oneDay)
            print(newSetting.twoDays)
            print(newSetting.threeDays)
         }
         else
         {
            let setting = Settings()
            setting.notifications = notifsCheckbox.isChecked ?? false
            setting.thatDay = thatDayCheckbox.isChecked ?? false
            setting.oneDay = oneDayCheckbox.isChecked ?? false
            setting.twoDays = twoDaysCheckbox.isChecked ?? false
            setting.threeDays = threeDaysCheckbox.isChecked ?? false
            print(setting.notifications)
            print(setting.thatDay)
            print(setting.oneDay)
            print(setting.twoDays)
            print(setting.threeDays)
            RealmHelper.addSettings(setting)
         }
         let temp: Results<Settings> = RealmHelper.retrieveSettings()
         listNotesTableViewController.setting = temp.last
         //   print(listNotesTableViewController.setting?.notifications)
      }
   }

}
