//
//  DateSpecifierTableViewCell.swift
//  ASUTrainingLog
//
//  Created by Luke Mason on 12/3/20.
//

import UIKit

// Class to support the training entry table cell for a date
class DateSpecifierTableViewCell: UITableViewCell {
    
    @IBOutlet var dateSpecifier: UIDatePicker! // Date picker for training day's date

    /* Functions out of the box of UITableViewCell */
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
        
    /*
     * Helper function to update the cell's date picker's settings
     */
    func update(with indexPath: IndexPath) {
        dateSpecifier.date = Date() // Auto set to today's date
        dateSpecifier.datePickerMode = .date // Set it to a date picker specifically
        dateSpecifier.preferredDatePickerStyle = .compact // Don't take up too much room
    }
    
    /*
     * Function to get the date value in the date picker
     * Return Date for current value in date picker
     */
    func getDate() -> Date {
        return dateSpecifier.date
    }
}
