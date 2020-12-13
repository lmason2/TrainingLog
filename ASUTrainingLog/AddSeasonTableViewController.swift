//
//  AddSeasonTableViewController.swift
//  ASUTrainingLog
//
//  Created by Luke Mason on 12/13/20.
//

import UIKit

class AddSeasonTableViewController: UITableViewController {
    
    var trainingDay: TrainingDay?
    
    @IBAction func createSeassonButtonPressed(sender: UIBarButtonItem) {
        createSeason()
        if let _ = trainingDay {
            performSegue(withIdentifier: "newEntry", sender: self)
        }
        else {
            performSegue(withIdentifier: "seasonTable", sender: self)
        }
    }

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
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let seasonNameCell = tableView.dequeueReusableCell(withIdentifier: "seasonNameCell", for: indexPath) as! SeasonNameTableViewCell
            seasonNameCell.backgroundColor = .white
            return seasonNameCell
        }
        else if (indexPath.section == 1) {
            let startDateCell = tableView.dequeueReusableCell(withIdentifier: "dateSpecifier", for: indexPath) as! DateSpecifierTableViewCell
            startDateCell.update(with: indexPath)
            startDateCell.backgroundColor = .white
            return startDateCell
        }
        else {
            let endDateCell = tableView.dequeueReusableCell(withIdentifier: "dateSpecifier", for: indexPath) as! DateSpecifierTableViewCell
            endDateCell.update(with: indexPath)
            endDateCell.backgroundColor = .white
            return endDateCell
        }
    }
    
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
    
    func createSeason() {
        
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
