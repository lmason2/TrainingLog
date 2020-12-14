//
//  TrainingEntryTableViewCell.swift
//  ASUTrainingLog
//
//  Created by Luke Mason on 12/3/20.
//

import UIKit

// Class to support the training entry table cell for mileage
class TrainingEntryTableViewCell: UITableViewCell {
    
    @IBOutlet var mileageLabel: UILabel! // Label to specify AM or PM
    @IBOutlet var mileageEntry: UITextField! // Text field to fill numerical mileage

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
     * Helper function to update the cell's labels
     */
    func update(with indexPath: IndexPath) {
        // Switch on the row to specify label
        switch (indexPath.row) {
            case 0:
                mileageLabel.text = "AM: "
            case 1:
                mileageLabel.text = "PM: "
            default:
                mileageLabel.text = "error"
        }
        mileageEntry.placeholder = "Mileage" // Set placeholder
    }
    
    /*
     * Function to get the mileage in the text field
     * Return Int for the mileage value
     */
    func getMileageEntry() -> Int?{
        if let mileageEntryString = mileageEntry.text {
            // There is an entry
            return Int(mileageEntryString)
        }
        return nil
    }
}
