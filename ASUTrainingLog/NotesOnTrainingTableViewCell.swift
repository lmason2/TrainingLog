//
//  NotesOnTrainingTableViewCell.swift
//  ASUTrainingLog
//
//  Created by Luke Mason on 12/5/20.
//

import UIKit

class NotesOnTrainingTableViewCell: UITableViewCell {
    
    @IBOutlet var notes: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
