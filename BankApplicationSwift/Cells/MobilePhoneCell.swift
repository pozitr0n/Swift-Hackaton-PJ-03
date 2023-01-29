//
//  MobilePhoneCell.swift
//  BankApplicationSwift
//
//  Created by Raman Kozar on 27/01/2023.
//

import UIKit

class MobilePhoneCell: UITableViewCell {

    @IBOutlet weak var phoneLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // Method for inserting mobile phone into table view cell
    //
    func insertPhoneIntoCell(phone: String) {
        phoneLabel.text = phone
    }

}
