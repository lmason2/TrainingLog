//
//  SeasonTableTableViewController.swift
//  ASUTrainingLog
//
//  Created by Luke Mason on 12/5/20.
//

import UIKit
import Firebase
import FirebaseFirestore

// Class to support the user looking at previous seasons' data
class SeasonTableTableViewController: UITableViewController {
    
    var username: String? // Username of uesr
    var seasons = [Season]() // Array of seasons for tableView data source
    var db: Firestore! // Reference to underlying data structure on cloud Firestore
    
    /*
     * Call back for the edit button to change the table into editing mode
     */
    @IBAction func editButtonPressed(sender: UIBarButtonItem) {
        let newEditingMode = !tableView.isEditing
        tableView.setEditing(newEditingMode, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        getSeasons()
    }

    /*
     * Function to set the number of sections in the table view
     */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    /*
     * Function to give the rows in a given section of the table view
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            // Return the length of the seasons
            return seasons.count
        }
        return 0
    }

    /*
     * Function to give the reusable cell to be used in the table
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get the season
        let season = seasons[indexPath.row]
        
        // All cells are simple subtitle cells
        let cell = tableView.dequeueReusableCell(withIdentifier: "simpleSub", for: indexPath)

        // Set appropriate text and detail labels
        cell.textLabel?.text = "\(season.name)"
        cell.detailTextLabel?.text = "Mileage: \(season.mileage)"

        return cell
    }
    
    /*
     * Function to handle the user wanting to delete a season
     */
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        showDeleteAlert(indexPath: indexPath)
    }
    
    /*
     * Function to prepare for segue to the week table
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            if id == "seasonToWeekSegue" {
                if let weekTVC = segue.destination as? WeeklyTableViewController {
                    if let indexPath = tableView.indexPathForSelectedRow {
                        // Having casted to appropriate controller, set local variables
                        let season = seasons[indexPath.row]
                        weekTVC.seasonName = season.name
                        weekTVC.username = self.username
                    }
                }
            }
        }
    }
    
    /*
     * Function to show an alert warning deletion consequences
     */
    func showDeleteAlert(indexPath: IndexPath) {
        // Create alert controller
        let alertController = UIAlertController(title: "Are You Sure?", message: "If you delete this season the data associated will also be deleted.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Yes, Delete.", style: .default, handler: { (action) -> Void in
            // User wants to delete
            // Get the season name
            let seasonName = self.seasons[indexPath.row].name
            
            // Delete the season and affiliated data
            self.db.collection("users").document(self.username!).collection("seasons").document(seasonName).delete() { err in
                if let err = err {
                    print("Error removing season: \(err)")
                } else {
                    print("Season successfully removed!")
                    // Remove the season from the table view's data source
                    self.seasons.remove(at: indexPath.row)
                    DispatchQueue.main.async {
                        // Remove editing mode and reload table view's data
                        self.tableView.isEditing = false
                        self.tableView.reloadData()
                    }
                }
            }
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    /*
     * Function to get the seasons from Firestore and set the table view's data source
     */
    func getSeasons() {
        seasons = [Season]() // Reset array
        
        // Query the database
        db.collection("users").document(username!).collection("seasons").order(by: "object.start date").getDocuments{ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    // Get dictionary object in season
                    let dictionaryOptional = document.data()["object"] as? NSDictionary
                    if let dictionary = dictionaryOptional {
                        // Get associated season info
                        let name = document.documentID
                        let startTS = dictionary["start date"] as? Timestamp
                        let endTS = dictionary["end date"] as? Timestamp
                        
                        // Cast time stamps to dates
                        let startDate = startTS?.dateValue()
                        let endDate = endTS?.dateValue()
                        
                        // Get mileage
                        let mileage = dictionary["mileage"] as? Int
                        
                        // Add the season to the array
                        self.seasons.append(Season(name: name, start: startDate!, end: endDate!, mileage: mileage!))
                        DispatchQueue.main.async {
                            // Reload the table view's data
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    /*
     * Callback to support unwind segues and grab the updated seasons
     */
    @IBAction func unwindToSeasonTableView(for segue: UIStoryboardSegue) {
        getSeasons()
    }
}
