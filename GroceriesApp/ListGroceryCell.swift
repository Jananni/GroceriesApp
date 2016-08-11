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

    @IBOutlet weak var shoppingButtonOnCell: UIButton!

    var delegate: ListGroceryCellDelegate!

    @IBOutlet weak var noteTitleLabel: UILabel!

    @IBOutlet weak var noteDaysLeft: UILabel!

    var shoppingClicked: Bool = false

    @IBAction func clickedShoppingButton(sender: AnyObject) {
        shoppingButtonOnCell.selected = !shoppingButtonOnCell.selected
        delegate!.buttonCellClicked(self)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //     shoppingButtonOnCell.setImage(UIImage(named: "shopping_cart_filled"), forState: UIControlState.Highlighted)
    }
}
