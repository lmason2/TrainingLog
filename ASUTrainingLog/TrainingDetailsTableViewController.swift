//
//  TrainingDetailsTableViewController.swift
//  ASUTrainingLog
//
//  Created by Luke Mason on 12/13/20.
//

import UIKit

// Class to handle the user wanting to see details on a training day
class TrainingDetailsTableViewController: UITableViewController {
    
    var day: TrainingDay? // The day to be shown

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    /*
     * Function to get the number of sections in the table view
     */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    /*
     * Function to get the number of rows in a section
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return 3
        }
        else if section == 2 {
            return 1
        }
        else {
            return 1
        }
    }

    /*
     * Function to set up the reusable cells for the table view
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // All cells are basic cells
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
        
        // Specify labels based on section and rows
        if indexPath.section == 0 {
            // Set the label to the date of training
            cell.textLabel?.text = day?.dayOfMonth
        }
        else if indexPath.section == 1 {
            // Set the label for mileage
            if indexPath.row == 0 {
                // Total mileage
                if let totalMileage = day?.totalMileage {
                    cell.textLabel?.text = "Total Mileage: \(totalMileage)"
                    cell.textLabel?.font = .boldSystemFont(ofSize: 20)
                }
            }
            else if indexPath.row == 1 {
                // Am Mileage
                if let amMileage = day?.amMileage {
                    cell.textLabel?.text = "AM Mileage: \(amMileage)"
                }
            }
            else {
                // Pm Mileage
                if let pmMileage = day?.pmMileage {
                    cell.textLabel?.text = "PM Mileage: \(pmMileage)"
                }
            }
        }
        else if indexPath.section == 2 {
            // Set the label for training specifier key
            cell.textLabel?.text = "" // Initialize string to be built up
            if let dayUnwrapped = day {
                if dayUnwrapped.easy {
                    // Easy day
                    cell.textLabel?.text! += "🔵"
                }
                if dayUnwrapped.workout {
                    // Workout day
                    cell.textLabel?.text! += "🔴"
                }
                if dayUnwrapped.race{
                    // Race day
                    cell.textLabel?.text! += "🟡"
                }
                if dayUnwrapped.longRun {
                    // Long run
                    cell.textLabel?.text! += "🟣"
                }
            }
        }
        else {
            // Add notes to details
            if let notes = day?.notes {
                cell.textLabel?.text = notes
            }
        }
        // Set all cell's background color to white to show contrast
        cell.backgroundColor = .white
        return cell
    }
    
    /*
     * Function to get the titles for section headers
     */
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
            case 0:
                return "Date"
            case 1:
                return "Mileage"
            case 2:
                return "Training Key"
            default:
                return "Notes"
                
        }
    }
    
    /*
     * Function to specify different height for notes section
     */
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 3 {
            // Extend height of note cell
            return 150
        }
        return tableView.estimatedRowHeight // Use default height
    }
}
