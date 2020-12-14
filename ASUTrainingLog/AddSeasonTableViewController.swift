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

class AddSeasonTableViewController: UITableViewController {
    
    var newEntry: Bool?
    var username: String?
    var seasonName: String?
    let db = Firestore.firestore()

    
    @IBAction func createSeassonButtonPressed(sender: UIBarButtonItem) {
        createSeason()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            if id == "newEntry" {
                if let newEntryTVC = segue.destination as? NewEntryTableViewController {
                    newEntryTVC.seasonName = self.seasonName
                }
            }
        }
    }
    
    
    func createSeason() {
        guard let seasonNameCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? SeasonNameTableViewCell, let startDateCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? DateSpecifierTableViewCell, let endDateCell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? DateSpecifierTableViewCell else {
            showFieldAlert()
            return
        }
        let startDate = startDateCell.getDate()
        let endDate = endDateCell.getDate()
        
        let nameOptional = seasonNameCell.getSeasonNameEntry()
        if let name = nameOptional {
            self.seasonName = name
            let seasonObject = NSMutableDictionary()
            seasonObject.addEntries(from: ["start date" : startDate])
            seasonObject.addEntries(from: ["end date" : endDate])
            seasonObject.addEntries(from: ["mileage" : 0])
            db.collection("users").document(username!).collection("seasons").document(name).setData(["object" : seasonObject]) { err in
                if let err = err {
                    print("Error updating seasons: \(err)")
                } else {
                    print("Seasons successfully updated")
                }
            }
            
            let days = endDate.timeIntervalSince(startDate) / (60*60*24)
            let weeks = Int(ceil(days/7))
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
