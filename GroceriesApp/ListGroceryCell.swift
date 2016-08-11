//
//  ListGroceryCell.swift
//  GroceriesApp
//
//  Created by Jananni Rathnagiri on 7/13/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import UIKit

protocol ListGroceryCellDelegate {
    func buttonCellClicked(cell: ListGroceryCell) -> Void
}

class ListGroceryCell: UITableViewCell {

    var delegate: ListGroceryCellDelegate!

    @IBOutlet weak var noteTitleLabel: UILabel!

    @IBOutlet weak var noteDaysLeft: UILabel!

    var shoppingClicked: Bool = false

    @IBAction func clickedShoppingButton(sender: AnyObject) {
        delegate!.buttonCellClicked(self)
    }
}
