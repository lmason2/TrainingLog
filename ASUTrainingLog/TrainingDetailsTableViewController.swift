//
//  TrainingDetailsTableViewController.swift
//  ASUTrainingLog
//
//  Created by Luke Mason on 12/13/20.
//

import UIKit

class TrainingDetailsTableViewController: UITableViewController {
    
    var day: TrainingDay?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
        
        if indexPath.section == 0 {
            cell.textLabel?.text = day?.dayOfMonth
        }
        else if indexPath.section == 1 {
            if indexPath.row == 0 {
                if let totalMileage = day?.totalMileage {
                    cell.textLabel?.text = "Total Mileage: \(totalMileage)"
                    cell.textLabel?.font = .boldSystemFont(ofSize: 20)
                }
            }
            else if indexPath.row == 1 {
                if let amMileage = day?.amMileage {
                    cell.textLabel?.text = "AM Mileage: \(amMileage)"
                }
            }
            else {
                if let pmMileage = day?.pmMileage {
                    cell.textLabel?.text = "PM Mileage: \(pmMileage)"
                }
            }
        }
        else if indexPath.section == 2 {
            cell.textLabel?.text = ""
            if let dayUnwrapped = day {
                if dayUnwrapped.easy {
                    cell.textLabel?.text! += "🔵"
                }
                if dayUnwrapped.workout {
                    cell.textLabel?.text! += "🔴"
                }
                if dayUnwrapped.race{
                    cell.textLabel?.text! += "🟡"
                }
                if dayUnwrapped.longRun {
                    cell.textLabel?.text! += "🟣"
                }
            }
        }
        else {
            if let notes = day?.notes {
                cell.textLabel?.text = notes
            }
        }
        cell.backgroundColor = .white

        return cell
    }
    
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 3 {
            return 150
        }
        return tableView.estimatedRowHeight
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
