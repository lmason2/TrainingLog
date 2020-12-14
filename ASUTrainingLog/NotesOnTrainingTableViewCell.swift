//
//  NotesOnTrainingTableViewCell.swift
//  ASUTrainingLog
//
//  Created by Luke Mason on 12/5/20.
//

import UIKit

// Class to support the training entry table cell for a notes cell
class NotesOnTrainingTableViewCell: UITableViewCell {
    
    @IBOutlet var notes: UITextView! // Text view to hold additional information on training

    /* Functions out of the box of UITableViewCell */
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        notes.textContainer.maximumNumberOfLines = 6
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /*
     * Function to get the value out of the text field if there is one
     * Return a String? that is set if there is information in the field
     */
    func getNotes() -> String?{
        if let notes = notes.text {
            return notes
        }
        else {
            return nil
        }
    }
}
