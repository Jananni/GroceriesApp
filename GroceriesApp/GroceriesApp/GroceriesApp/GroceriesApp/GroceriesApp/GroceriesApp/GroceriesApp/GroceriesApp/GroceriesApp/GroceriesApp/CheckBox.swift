//
//  CheckBox.swift
//  GroceriesApp
//
//  Created by Jananni Rathnagiri on 7/12/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import UIKit

class CheckBox: UIButton {


   let checkedButtonImage = UIImage(named: "checked")
   let uncheckedButtonImage = UIImage(named: "Unchecked")

   var isChecked:Bool = false {
      didSet{
         if isChecked == true {
            self.setImage(checkedButtonImage, forState: .Normal)
         }else{
            self.setImage(uncheckedButtonImage, forState: .Normal)
         }
      }
   }

   override func awakeFromNib() {
      self.addTarget(self, action: #selector(CheckBox.buttonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
      self.isChecked = false
   }

   func buttonClicked(sender:UIButton) {
      if(sender == self)
      {
         if isChecked == true{
            isChecked = false
         }else{
            isChecked = true
         }
      }
   }

   

}
