//
//  WeeklyTableViewController.swift
//  ASUTrainingLog
//
//  Created by Luke Mason on 12/13/20.
//

import UIKit
import Firebase
import FirebaseFirestore

// Class to support user looking at past weeks' data
class WeeklyTableViewController: UITableViewController {
    
    var weeks = [Week]() // Array for table view's data source
    var seasonName: String? // Season name associated with the week array
    var username: String? // Username of user
    var db: Firestore! // Reference to cloud Firestore database

    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        getWeeks()
    }

    /*
     * Function to show the number of sections in the table view
     */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    /*
     * Function to show the number of rows in a given section for the table view
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeks.count
    }

    /*
     * Function to get the reusable cells for the table view
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // All cells are simple subtitle cells
        let cell = tableView.dequeueReusableCell(withIdentifier: "simpleSub", for: indexPath)
        
        // Get the week at the index
        let week = weeks[indexPath.row]

        // Set the text and subtitle labels as appropriate
        cell.textLabel?.text = "Week \(week.number)"
        cell.detailTextLabel?.text = "Mileage: \(week.mileage)"

        return cell
    }
    
    /*
     * Function to get the weeks from the Firestore database and populate the weeks array
     */
    func getWeeks() {
        weeks = [Week]() // Reset array
        
        // Query the database
        db.collection("users").document(username!).collection("seasons").document(seasonName!).collection("weeks").getDocuments{ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    // Get the associated information with the weeks
                    let weekName = document.documentID
                    let weekNumber = weekName[weekName.index(weekName.endIndex, offsetBy: -1)]
                    let mileage = document.data()["mileage"]
                    
                    // Append the week into the array
                    self.weeks.append(Week(number: Int(String(weekNumber))!, mileage: mileage as! Int))
                    DispatchQueue.main.async {
                            self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    /*
     * Function to prepare for segue to day table
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            if id == "weekToDaySegue" {
                if let dayTVC = segue.destination as? DaysTableViewController {
                    if let indexPath = tableView.indexPathForSelectedRow {
                        // Having casted to the Day controller, set local variables to destination
                        let week = weeks[indexPath.row]
                        dayTVC.weekName = week.number
                        dayTVC.seasonName = self.seasonName
                        dayTVC.username = self.username
                    }
                }
            }
        }
    }
}
