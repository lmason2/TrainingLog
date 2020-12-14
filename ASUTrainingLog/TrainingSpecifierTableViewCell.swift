//
//  TrainingSpecifierTableViewCell.swift
//  ASUTrainingLog
//
//  Created by Luke Mason on 12/3/20.
//

import UIKit

// Class to support the training entry table cell for training types
class TrainingSpecifierTableViewCell: UITableViewCell {

    @IBOutlet var trainingType: UILabel! // Label to specify switch's purpose
    @IBOutlet var typeSwitch: UISwitch!

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
        // Switch on row to specify
        switch (indexPath.row) {
            case 0:
                trainingType.text = "Easy Day 🔵"
                typeSwitch.isOn = false
                typeSwitch.tag = 0
            case 1:
                trainingType.text = "Workout Day 🔴"
                typeSwitch.isOn = false
                typeSwitch.tag = 1
            case 2:
                trainingType.text = "Race Day 🟡"
                typeSwitch.isOn = false
                typeSwitch.tag = 2
            case 3:
                trainingType.text = "Long Run 🟣"
                typeSwitch.isOn = false
                typeSwitch.tag = 3
            default:
                trainingType.text = "No Type"
                typeSwitch.isOn = false
        }
    }
    
    /*
     * Helper function to get the switches value
     * Return Bool for the value of the given switch
     */
    func getSwitchValue() -> Bool {
        return typeSwitch.isOn
    }
}
