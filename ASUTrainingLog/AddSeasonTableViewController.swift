//
//  AddSeasonTableViewController.swift
//  ASUTrainingLog
//
//  Created by Luke Mason on 12/13/20.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseFirestore

// Class to support the user adding a new season
class AddSeasonTableViewController: UITableViewController {
    
    var username: String? // Username of the logged in user
    var seasonName: String? // Name of the season to be filled
    let db = Firestore.firestore() // Reference to Firestore database

    /*
     * Callback for the user wanting to create a season
     */
    @IBAction func createSeassonButtonPressed(sender: UIBarButtonItem) {
        createSeason()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    /*
     * Function to give the table view the number of sections
     */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    /*
     * Function to give the table view the number of rows in a section
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    /*
     * Function to handle reusable cells for the table view
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            // Set the season name in a text view
            let seasonNameCell = tableView.dequeueReusableCell(withIdentifier: "seasonNameCell", for: indexPath) as! SeasonNameTableViewCell
            seasonNameCell.backgroundColor = .white
            return seasonNameCell
        }
        else if (indexPath.section == 1) {
            // Set the season start date
            let startDateCell = tableView.dequeueReusableCell(withIdentifier: "dateSpecifier", for: indexPath) as! DateSpecifierTableViewCell
            startDateCell.update(with: indexPath)
            startDateCell.backgroundColor = .white
            return startDateCell
        }
        else {
            // Set the season end date
            let endDateCell = tableView.dequeueReusableCell(withIdentifier: "dateSpecifier", for: indexPath) as! DateSpecifierTableViewCell
            endDateCell.update(with: indexPath)
            endDateCell.backgroundColor = .white
            return endDateCell
        }
    }
    
    /*
     * Function to give the table view the titles for section headers
     */
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
            case 0:
                return "Season Name"
            case 1:
                return "Start Date"
            case 2:
                return "End Date"
            default:
                return "Misc"
        }
    }
    
    /*
     * Function to prepare for a segue back to the training entry screen
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            if id == "newEntry" {
                if let newEntryTVC = segue.destination as? NewEntryTableViewController {
                    // Set the new season name
                    newEntryTVC.seasonName = self.seasonName
                }
            }
        }
    }
    
    /*
     * Function to handle creation of a new season
     */
    func createSeason() {
        // Make sure seasons are set
        guard let seasonNameCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? SeasonNameTableViewCell, let startDateCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? DateSpecifierTableViewCell, let endDateCell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? DateSpecifierTableViewCell else {
            showFieldAlert()
            return
        }
        
        // Get dates
        let startDate = startDateCell.getDate()
        let endDate = endDateCell.getDate()
        
        let nameOptional = seasonNameCell.getSeasonNameEntry()
        if let name = nameOptional {
            // Set loacl season name to new name
            self.seasonName = name
            
            // Build the object to be inserted
            let seasonObject = NSMutableDictionary()
            seasonObject.addEntries(from: ["start date" : startDate])
            seasonObject.addEntries(from: ["end date" : endDate])
            seasonObject.addEntries(from: ["mileage" : 0]) // Default to 0
            
            // Add the object to the appropriate path
            db.collection("users").document(username!).collection("seasons").document(name).setData(["object" : seasonObject]) { err in
                if let err = err {
                    print("Error updating seasons: \(err)")
                } else {
                    print("Seasons successfully updated")
                }
            }
            
            // Calculate the composition values to build out the weeks
            let days = endDate.timeIntervalSince(startDate) / (60*60*24)
            let weeks = Int(ceil(days/7))
            
            // Loop to create weeks objects in new season
            for i in 0..<weeks {
                db.collection("users").document(username!).collection("seasons").document(name).collection("weeks").document("Week \(i + 1)").setData(["mileage" : 0]) { err in
                    if let err = err {
                        print("Error updating weeks: \(err)")
                    } else {
                        print("Weeks successfully updated")
                        self.performSegue(withIdentifier: "newEntry", sender: self)
                    }
                }
            }
        }
    }
        
    func showFieldAlert() {
        let alertController = UIAlertController(title: "Fill All Fields", message: "Season name must be filled", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
