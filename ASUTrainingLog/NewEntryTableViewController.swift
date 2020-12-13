//
//  NewEntryTableViewController.swift
//  ASUTrainingLog
//
//  Created by Luke Mason on 12/3/20.
//

import UIKit

class NewEntryTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let mileageCell = tableView.dequeueReusableCell(withIdentifier: "mileageEntry", for: indexPath) as! TrainingEntryTableViewCell
            mileageCell.update(with: indexPath)
            mileageCell.backgroundColor = .white
            return mileageCell
        }
        else if (indexPath.section == 1) {
            let typeCell = tableView.dequeueReusableCell(withIdentifier: "trainingSpecifier", for: indexPath) as! TrainingSpecifierTableViewCell
            typeCell.update(with: indexPath)
            typeCell.backgroundColor = .white
            return typeCell
        }
        else if (indexPath.section == 2){
            let dateCell = tableView.dequeueReusableCell(withIdentifier: "dateSpecifier", for: indexPath) as! DateSpecifierTableViewCell
            dateCell.update(with: indexPath)
            dateCell.backgroundColor = .white
            return dateCell
        }
        else {
            let notesCell = tableView.dequeueReusableCell(withIdentifier: "notesOnTraining", for: indexPath) as! NotesOnTrainingTableViewCell
            notesCell.backgroundColor = .white
            return notesCell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 3 {
            return 100
        }
        return tableView.estimatedRowHeight
    }
    
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
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "saveTraining" {
            guard
                let _ = (tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TrainingEntryTableViewCell).getMileageEntry(), let _ =  (tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! TrainingEntryTableViewCell).getMileageEntry()
                else {
                giveInputAlert()
                return false
            }
            
            // Check if the date overlaps with existing seasons
            if true {
                showSeasonCreationAlert()
                return false
            }
            return true
        }
        return false
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            if id == "saveTraining" {
                // Get mileage values
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
                
                addData(amMileage: amMileage, pmMileage: pmMileage, switchArray: switchValues, dateOfTraining: date)
            }
            else if id == "addSeasonSegue" {
                if let addSeasonTVC = segue.destination as? AddSeasonTableViewController {
                    addSeasonTVC.trainingDay = TrainingDay(amMileage: 8, pmMileage: 4, dayOfMonth: "Monday")
                }
            }
        }
    }
    
    func giveInputAlert() {
        let alertController = UIAlertController(title: "Fill Mileage Fields", message: "AM and PM mileage must be set", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func showSeasonCreationAlert() {
        let alertController = UIAlertController(title: "New Season", message: "The dates you set are not within a season. Would you like to create one?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Create Season", style: .default, handler: { (action) -> Void in
            self.performSegue(withIdentifier: "addSeasonSegue", sender: self)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func addData(amMileage: Int, pmMileage: Int, switchArray: [Bool], dateOfTraining date: Date) {
        // add to cloud firestore
    }
    
    @IBAction func unwindToNewEntryTableView(for segue: UIStoryboardSegue) {
        
    }

        
//    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        let header = view as! UITableViewHeaderFooterView
//        header.textLabel?.textColor = .black
//        header.backgroundColor = .white
//    }
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

}
