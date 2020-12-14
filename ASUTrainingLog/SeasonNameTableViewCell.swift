//
//  SeasonNameTableViewCell.swift
//  ASUTrainingLog
//
//  Created by Luke Mason on 12/13/20.
//

import UIKit

// Class to support the new season table cell for season name
class SeasonNameTableViewCell: UITableViewCell {
    
    @IBOutlet var seasonNameEntry: UITextField! // Name of new season

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
     * Function to get the value in the season text field
     * Return String? that has the value if there is one
     */
    func getSeasonNameEntry() -> String?{
        if let seasonName = seasonNameEntry.text {
            return seasonName
        }
        return nil
    }

}
