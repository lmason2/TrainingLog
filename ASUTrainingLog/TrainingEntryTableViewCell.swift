//
//  TrainingEntryTableViewCell.swift
//  ASUTrainingLog
//
//  Created by Luke Mason on 12/3/20.
//

import UIKit

class TrainingEntryTableViewCell: UITableViewCell {
    
    @IBOutlet var mileageLabel: UILabel!
    @IBOutlet var mileageEntry: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
        
    func update(with indexPath: IndexPath) {
        switch (indexPath.row) {
        case 0:
            mileageLabel.text = "AM: "
        case 1:
            mileageLabel.text = "PM: "
        default:
            mileageLabel.text = "error"
        }
        mileageEntry.placeholder = "Mileage"
    }
    
    func getMileageEntry() -> Int?{
        if let mileageEntryString = mileageEntry.text {
            return Int(mileageEntryString)
        }
        return nil
    }

}
