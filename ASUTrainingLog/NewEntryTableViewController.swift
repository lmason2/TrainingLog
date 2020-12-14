//
//  NewEntryTableViewController.swift
//  ASUTrainingLog
//
//  Created by Luke Mason on 12/3/20.
//

import UIKit
import Firebase
import FirebaseFirestore
import MBProgressHUD

// Class to give the user the ability to add training
class NewEntryTableViewController: UITableViewController {
    
    var username: String? // The user's username
    var db: Firestore! // Reference to cloud storage
    var seasonName: String? // The name of the season to add the training to
    
    /*
     * Function callback for the save button being pressed
     */
    @IBAction func saveButtonPressed(sender: UIBarButtonItem) {
        // Check that all necessary fields are filled
        guard
            let _ = (tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TrainingEntryTableViewCell).getMileageEntry(), let _ =  (tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! TrainingEntryTableViewCell).getMileageEntry()
            else {
            // Show the user an alert to fill fields
            giveInputAlert()
            return
        }
        
        // All fields are filled, get the date to check if it is in a current season
        let dateCell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? DateSpecifierTableViewCell
        let date = (dateCell?.getDate())!
        
        // Check if the user needs to create a new season
        needNewSeason(date: date, completion: {(seasonNameOptional) in
            if let seasonName = seasonNameOptional {
                // Season name is set, user does not need a new season, perform the segue to home screen
                self.seasonName = seasonName
                self.performSegue(withIdentifier: "saveTraining", sender: self)
            }
            else {
                // User needs to create a new season for the sepcified date
                self.showSeasonCreationAlert()
            }
        })
    }
    
    /*
     * Unwind function to support unwind segue from add season controller
     */
    @IBAction func unwindToNewEntryTableView(for segue: UIStoryboardSegue) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        self.navigationItem.backBarButtonItem?.tintColor = .white
    }

    /*
     * Function to specify the table view's number of sections
     */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    /*
     * Function to specify the number of rows in each section of the table view
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        else if section == 1 {
            return 4
        }
        else if section == 2 {
            return 1
        }
        else if section == 3 {
            return 1
        }
        return 0
    }

    /*
     * Function to specify the reusable cells to be used at each section and row
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            // Mileage entry cells
            let mileageCell = tableView.dequeueReusableCell(withIdentifier: "mileageEntry", for: indexPath) as! TrainingEntryTableViewCell
            mileageCell.update(with: indexPath)
            mileageCell.backgroundColor = .white
            return mileageCell
        }
        else if (indexPath.section == 1) {
            // Training type cells
            let typeCell = tableView.dequeueReusableCell(withIdentifier: "trainingSpecifier", for: indexPath) as! TrainingSpecifierTableViewCell
            typeCell.update(with: indexPath)
            typeCell.backgroundColor = .white
            return typeCell
        }
        else if (indexPath.section == 2){
            // Date cell
            let dateCell = tableView.dequeueReusableCell(withIdentifier: "dateSpecifier", for: indexPath) as! DateSpecifierTableViewCell
            dateCell.update(with: indexPath)
            dateCell.backgroundColor = .white
            return dateCell
        }
        else {
            // Note cel
            let notesCell = tableView.dequeueReusableCell(withIdentifier: "notesOnTraining", for: indexPath) as! NotesOnTrainingTableViewCell
            notesCell.backgroundColor = .white
            return notesCell
        }
    }
    
    /*
     * Function to give the height of specific cells in the table view
     */
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 3 {
            // Notes cell needs to be taller to support longer text entry
            return 150
        }
        return tableView.estimatedRowHeight // Remaining rows are default
    }
    
    /*
     * Function to give the section headers for each section
     */
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
            case 0:
                return "Mileage"
            case 1:
                return "Training Type"
            case 2:
                return "Date"
            case 3:
                return "Notes"
            default:
                return "Misc"
        }
    }
    
    /*
     * Function to determine if the user needs a new season
     */
    func needNewSeason(date: Date, completion: @escaping (String?) -> Void) {
        // Query the seasons collection
        db.collection("users").document(username!).collection("seasons").getDocuments{ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    // For each season name, get the object
                    let seasonObject = document.data()["object"] as! NSMutableDictionary
                    
                    // Get the dates from the object
                    let startDate = seasonObject["start date"] as! Timestamp
                    let endDate = seasonObject["end date"] as! Timestamp
                    
                    // Set up date formatter for comparison and time zone adjustment
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeZone = NSTimeZone.local
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    
                    // Adjust dates
                    let adjustedStartDate = dateFormatter.string(from: startDate.dateValue())
                    let adjustedEndDate = dateFormatter.string(from: endDate.dateValue())
                    let adjustedDate = dateFormatter.string(from: date)
                    
                    // Make the comparison
                    if (adjustedDate >= adjustedStartDate && adjustedDate <= adjustedEndDate) {
                        // User does not need a new season
                        DispatchQueue.main.async {
                            // Pass back document id through completion handler
                            completion(document.documentID)
                            return
                        }
                    }
                }
                // User needs a new season
                DispatchQueue.main.async {
                    // Return nil for optional check in save button callback
                    completion(nil)
                    return
                }
            }
        }
    }
    
    /*
     * Function to prepare for segues
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            // Get the index of the am and pm mileages and their values
            let amIndex = IndexPath(row: 0, section: 0)
            let amMileage = (tableView.cellForRow(at: amIndex) as! TrainingEntryTableViewCell).getMileageEntry()!
            let pmIndex = IndexPath(row: 1, section: 0)
            let pmMileage = (tableView.cellForRow(at: pmIndex) as! TrainingEntryTableViewCell).getMileageEntry()!
            
            // Get switch values
            var switchValues = [Bool]()
            for i in 0..<4 {
                let index = IndexPath(row: i, section: 1)
                let switchValue = (tableView.cellForRow(at: index) as! TrainingSpecifierTableViewCell).getSwitchValue()
                switchValues.append(switchValue)
            }
            
            // Get date
            let dateIndex = IndexPath(row: 0, section: 2)
            let date = (tableView.cellForRow(at: dateIndex) as! DateSpecifierTableViewCell).getDate()
            
            // Get notes
            let noteIndex = IndexPath(row: 0, section: 3)
            let notes = (tableView.cellForRow(at: noteIndex) as! NotesOnTrainingTableViewCell).getNotes()
            if id == "saveTraining" {
                // User is saving data, need to add the data to Firestore
                addData(amMileage: amMileage, pmMileage: pmMileage, switchArray: switchValues, dateOfTraining: date, notes: notes, username: username!)
            }
            else if id == "addSeasonSegue" {
                // User needs to add a season, send them to the appropriate controller
                if let addSeasonTVC = segue.destination as? AddSeasonTableViewController {
                    // Set local variables of destination controller
                    addSeasonTVC.newEntry = true
                    addSeasonTVC.username = self.username
                }
            }
        }
    }
    
    /*
     * Function to alert the user that they need to fill more inputs
     */
    func giveInputAlert() {
        let alertController = UIAlertController(title: "Fill Mileage Fields", message: "AM and PM mileage must be set", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    /*
     * Function to show the user they need to create a season
     */
    func showSeasonCreationAlert() {
        let alertController = UIAlertController(title: "New Season", message: "The dates you set are not within a season. Would you like to create one?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Create Season", style: .default, handler: { (action) -> Void in
            // They want to create a new season, perform the segue
            self.performSegue(withIdentifier: "addSeasonSegue", sender: self)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    /*
     * User's data has been validated and has a season, add it needs to be added to Firestore
     */
    func addData(amMileage: Int, pmMileage: Int, switchArray: [Bool], dateOfTraining date: Date, notes: String?, username: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        // Get the document for the appropriate season
        db.collection("users").document(username).collection("seasons").document(seasonName!).getDocument { (document, error) in
            if let document = document, document.exists {
                if let seasonObject = document.data() {
                    // Get the object from the season document
                    if let objectDictionary = seasonObject["object"] as? NSMutableDictionary{
                        
                        // Mileage needs to be updated with new training day entry
                        // Get current season mileage, and then update with new day's mileage
                        let currSeasonMileage = objectDictionary["mileage"] as! Int
                        self.db.collection("users").document(username).collection("seasons").document(self.seasonName!).updateData(["object.mileage" : currSeasonMileage + amMileage + pmMileage])
                        
                        // Get dates
                        if let startDateTS = objectDictionary["start date"] as? Timestamp {
                            // Set up date formatter for time zone and day allocation
                            let dateFormatter = DateFormatter()
                            dateFormatter.timeZone = NSTimeZone.local
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            
                            // Adjust appropriate date values to get to comparable and accurate date time
                            let adjustedStartString = dateFormatter.string(from: startDateTS.dateValue())
                            let adjustedCurrString = dateFormatter.string(from: date)
                            let adjustedStartDate = dateFormatter.date(from: adjustedStartString)
                            let adjustedCurrDate = dateFormatter.date(from: adjustedCurrString)
                            
                            // Calculate composition values
                            let dayOfSeason = Int(ceil(adjustedCurrDate!.timeIntervalSince(adjustedStartDate!) / (60*60*24)))
                            let week = (dayOfSeason / 7) + 1
                            let dayOfWeek = (dayOfSeason % 7) + 1
                            
                            // Update week mileage
                            self.db.collection("users").document(username).collection("seasons").document(self.seasonName!).collection("weeks").document("Week \(week)").getDocument {(weekDoc, error) in
                                if let weekDoc = weekDoc, weekDoc.exists {
                                    // Get object holding the week
                                    if let weekObject = weekDoc.data() {
                                        // Get the current week mileage
                                        let currWeekMileage = weekObject["mileage"] as! Int
                                        
                                        // Update the mileage to add new day's mileage
                                        self.db.collection("users").document(username).collection("seasons").document(self.seasonName!).collection("weeks").document("Week \(week)").updateData(["mileage" : currWeekMileage + amMileage + pmMileage])
                                    }
                                }
                            }
                    
                            // Write training day in
                            self.db.collection("users").document(username).collection("seasons").document(self.seasonName!).collection("weeks").document("Week \(week)").collection("days").document("Day \(dayOfWeek)").setData([
                                "AM Mileage" : amMileage,
                                "PM Mileage" : pmMileage,
                                "Total Mileage" : amMileage + pmMileage,
                                "Easy Day?" : switchArray[0],
                                "Workout Day?" : switchArray[1],
                                "Race Day?" : switchArray[2],
                                "Long Run?" : switchArray[3],
                                "Date" : Timestamp(date: date),
                                "Notes" : notes ?? "none"
                            ]) { err in
                                if let err = err {
                                    print("Error adding training: \(err)")
                                } else {
                                    print("Training successfully added")
                                }
                            }
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                    }
                }
            } else {
                print("Error")
            }
        }
    }
}
