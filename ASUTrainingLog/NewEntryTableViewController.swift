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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        else if section == 1 {
            return 4
        }
        else if section == 2 {
            return 2
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let mileageCell = tableView.dequeueReusableCell(withIdentifier: "mileageEntry", for: indexPath) as! TrainingEntryTableViewCell
            mileageCell.update(with: indexPath)
            return mileageCell
        }
        else if (indexPath.section == 1) {
            let typeCell = tableView.dequeueReusableCell(withIdentifier: "trainingSpecifier", for: indexPath) as! TrainingSpecifierTableViewCell
            typeCell.update(with: indexPath)
            return typeCell
        }
        else {
            let dateCell = tableView.dequeueReusableCell(withIdentifier: "dateSpecifier", for: indexPath) as! DateSpecifierTableViewCell
            dateCell.update(with: indexPath)
            return dateCell
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        if section == 0 {
            label.text = "Mileage"
        }
        else if section == 1 {
            label.text = "Type of run"
        }
        else {
            label.text = "Date"
        }
        label.backgroundColor = .lightGray
        return label
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
