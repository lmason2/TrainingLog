//
//  DaysTableViewController.swift
//  ASUTrainingLog
//
//  Created by Luke Mason on 12/13/20.
//

import UIKit
import Firebase
import FirebaseFirestore
import MBProgressHUD

// Class to support user looking at day's training table for a particular week
class DaysTableViewController: UITableViewController {
    
    var days = [TrainingDay]() // Array of days in the week
    var username: String? // Username for user
    var seasonName: String? // Season that the days are in
    var weekName: Int? // Week number that the days are in
    var db: Firestore! // Reference to Firestore database
    
    /*
     * Callback function for when user wants to edit the table
     */
    @IBAction func editButtonPressed (_ sender: UIBarButtonItem) {
        let newEditingMode = !tableView.isEditing
        tableView.setEditing(newEditingMode, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        getDays()
    }

    /*
     * Function to get the number of sections in the table view
     */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    /*
     * Function to get the number of rows in a given section for the table view
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            // Give the amount of days in the array
            return days.count
        }
        return 0
    }

    /*
     * Function to specify reusable cells in the table view
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // All cells will have a title and a right sided descriptor
        let cell = tableView.dequeueReusableCell(withIdentifier: "rightSide", for: indexPath)

        // Get the day for the row
        let day = days[indexPath.row]
        
        // Set the appropriate labels and right detail for training specifier
        cell.textLabel?.text = day.dayName
        cell.detailTextLabel?.text = ""
        
        // Check for color coded training day specifiers
        if day.easy {
            cell.detailTextLabel?.text! += "🔵"
        }
        if day.workout {
            cell.detailTextLabel?.text! += "🔴"
        }
        if day.race{
            cell.detailTextLabel?.text! += "🟡"
        }
        if day.longRun {
            cell.detailTextLabel?.text! += "🟣"
        }

        return cell
    }
    
    /*
     * Function to handle editing of table
     */
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // User wants to delete
        showDeleteAlert(indexPath: indexPath)
    }
    
    /*
     * Function to warn the user of deletion consequences and carry out deletion
     * params: indexPath - the indexPath of the row to be deleted
     */
    func showDeleteAlert(indexPath: IndexPath) {
        // Create alert controllers
        let alertController = UIAlertController(title: "Are You Sure?", message: "If you delete this day the data associated will also be deleted.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Yes, Delete.", style: .default, handler: { (action) -> Void in
            // User wants to delete
            
            // Get the day name at the deleted row
            let dayName = self.days[indexPath.row].dayName
            
            // Get the mileage for that day
            self.getDayToBeDeletedMileage(with: dayName, completion: {(mileage) in
                if let mileageUnwrapped = mileage {
                    // Mileage has been set, adjust the season and week's mileage accordingly
                    self.adjustWeekAndMonthMileage(less: mileageUnwrapped)
                    
                    // Remove the day to be deleted
                    self.db.collection("users").document(self.username!).collection("seasons").document(self.seasonName!).collection("weeks").document("Week \(self.weekName!)").collection("days").document(dayName).delete() { err in
                        if let err = err {
                            print("Error removing day: \(err)")
                        } else {
                            print("Day successfully removed!")
                            self.days.remove(at: indexPath.row)
                            DispatchQueue.main.async {
                                // Set editing to false and update the table view's data
                                self.tableView.isEditing = false
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            })
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    /*
     * Function to handle getting the mileage from the day to be deleted
     * params: day - the name of the day to be deleted
     *         completion - a closure to handle querying the Firestore database
     */
    func getDayToBeDeletedMileage(with day: String, completion: @escaping (Int?) -> Void) {
        // Query the database
        db.collection("users").document(username!).collection("seasons").document(seasonName!).collection("weeks").document("Week \(weekName!)").collection("days").document(day).getDocument { (document, error) in
            if let document = document, document.exists {
                // Get the object in the data
                if let object = document.data() {
                    // Get the mileage value
                    let mileage = object["Total Mileage"] as! Int
                    DispatchQueue.main.async {
                        // Pass the value back through completion handler
                        completion(mileage)
                    }
                }
            } else {
                // No mileage to be passed
                completion(nil)
            }
        }
    }
    
    /*
     * Function to adjust the mileage of the season and week containing the deleted day
     * params: mileage - the amount of miles to be deducted from the season and week
     */
    func adjustWeekAndMonthMileage(less mileage: Int) {
        // Read the current week information
        self.db.collection("users").document(username!).collection("seasons").document(self.seasonName!).collection("weeks").document("Week \(weekName!)").getDocument {(weekDoc, error) in
            if let weekDoc = weekDoc, weekDoc.exists {
                // Get the object with the data
                if let weekObject = weekDoc.data() {
                    // Get the current mileage
                    let currWeekMileage = weekObject["mileage"] as! Int
                    
                    // Update the mileage
                    self.db.collection("users").document(self.username!).collection("seasons").document(self.seasonName!).collection("weeks").document("Week \(self.weekName!)").updateData(["mileage" : currWeekMileage - mileage])
                }
            }
        }
        
        // Read the current season information
        self.db.collection("users").document(username!).collection("seasons").document(self.seasonName!).getDocument {(seasonDoc, error) in
            if let seasonDoc = seasonDoc, seasonDoc.exists {
                // Get the object with the data
                if let seasonObject = seasonDoc.data() {
                    let objectDictionary = seasonObject["object"] as! NSMutableDictionary
                    
                    // Get the current mileage
                    let currMonthMileage = objectDictionary["mileage"] as! Int
                    
                    // Update the mileage
                    self.db.collection("users").document(self.username!).collection("seasons").document(self.seasonName!).updateData(["object.mileage" : currMonthMileage - mileage])
                }
            }
        }
    }
    
    /*
     * Function to query the Firestore database for the days
     */
    func getDays() {
        days = [TrainingDay]() // Reset days array
        
        // Query the database
        db.collection("users").document(username!).collection("seasons").document(seasonName!).collection("weeks").document("Week \(weekName!)").collection("days").getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    // Grab the day's information
                    let dayName = document.documentID
                    let amMileage = document.data()["AM Mileage"] as! Int
                    let pmMileage = document.data()["PM Mileage"] as! Int
                    let easyDay = document.data()["Easy Day?"] as! Bool
                    let workoutDay = document.data()["Workout Day?"] as! Bool
                    let raceDay = document.data()["Race Day?"] as! Bool
                    let longRun = document.data()["Long Run?"] as! Bool
                    let notes = document.data()["Notes"] as! String
                    let date = document.data()["Date"] as! Timestamp
                    
                    // Format the dates to correct for timezones
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeZone = NSTimeZone.local
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let adjustedDate = dateFormatter.string(from: date.dateValue())
                    
                    // Add the day to the array
                    self.days.append(TrainingDay(amMileage: amMileage, pmMileage: pmMileage, dayOfMonth: adjustedDate, dayName: dayName, easy: easyDay, workout: workoutDay, race: raceDay, longRun: longRun, notes: notes))
                    DispatchQueue.main.async {
                        // Reload the table view data
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    /*
     * Function to prepare for a segue to a detail page on the training day
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            if id == "detailSegue" {
                if let detailTVC = segue.destination as? TrainingDetailsTableViewController {
                    if let indexPath = tableView.indexPathForSelectedRow {
                        // Set the day to be shown to the one at the row selected
                        let day = days[indexPath.row]
                        detailTVC.day = day
                    }
                }
            }
        }
    }
}
