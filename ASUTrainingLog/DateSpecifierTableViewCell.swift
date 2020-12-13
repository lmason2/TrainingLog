//
//  DateSpecifierTableViewCell.swift
//  ASUTrainingLog
//
//  Created by Luke Mason on 12/3/20.
//

import UIKit

class DateSpecifierTableViewCell: UITableViewCell {
    
    @IBOutlet var dateSpecifier: UIDatePicker!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
        
    func update(with indexPath: IndexPath) {
        dateSpecifier.date = Date()
        dateSpecifier.datePickerMode = .date
        dateSpecifier.preferredDatePickerStyle = .compact
    }
    
    func getDate() -> Date {
        return dateSpecifier.date
    }

}
