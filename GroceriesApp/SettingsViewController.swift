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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      let listNotesTableViewController = segue.destinationViewController as! SettingsViewController
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
            RealmHelper.saveSettings(setting, newSettings: newSetting)
         }
         let temp: Results<Settings> = RealmHelper.retrieveSettings()
         listNotesTableViewController.setting = temp[0]
      }
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
