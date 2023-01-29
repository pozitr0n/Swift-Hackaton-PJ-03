//
//  HistoryCell.swift
//  BankApplicationSwift
//
//  Created by Raman Kozar on 27/01/2023.
//

import UIKit

class HistoryCell: UITableViewCell {

    @IBOutlet weak var operationDataLabel: UILabel!
    @IBOutlet weak var operationTypeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // Method for inserting all the main fields into the table view cell
    //
    func insertInfoAboutOperation(operationDataValue: Date, operationTypeValue: String, amountValue: Float) {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "dd-MM-yyyy hh:mm"
        
        let dateForRecord = formatter.string(from: operationDataValue as Date)
        
        operationDataLabel.text     = dateForRecord
        operationTypeLabel.text     = operationTypeValue
        amountLabel.text            = String(round(amountValue * 100) / 100)
        
    }

}
