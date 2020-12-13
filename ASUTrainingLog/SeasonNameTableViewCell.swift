//
//  SeasonNameTableViewCell.swift
//  ASUTrainingLog
//
//  Created by Luke Mason on 12/13/20.
//

import UIKit

class SeasonNameTableViewCell: UITableViewCell {
    
    @IBOutlet var seasonNameEntry: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getSeasonNameEntry() -> String?{
        if let seasonName = seasonNameEntry.text {
            return seasonName
        }
        return nil
    }

}
