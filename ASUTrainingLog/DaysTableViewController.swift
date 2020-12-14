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

class DaysTableViewController: UITableViewController {
    
    var days = [TrainingDay]()
    var username: String?
    var seasonName: String?
    var weekName: Int?
    var db: Firestore!
    
    @IBAction func editButtonPressed (_ sender: UIBarButtonItem) {
        let newEditingMode = !tableView.isEditing
        tableView.setEditing(newEditingMode, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()

        getDays()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return days.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rightSide", for: indexPath)

        let day = days[indexPath.row]
        
        cell.textLabel?.text = day.dayName
        cell.detailTextLabel?.text = ""
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        showDeleteAlert()
    }
    
    func showDeleteAlert() {
        let alertController = UIAlertController(title: "Are You Sure?", message: "If you delete this day the data associated will also be deleted.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Yes, Delete.", style: .default, handler: { (action) -> Void in
            // Delete associated day in firestore
            // Delete row from table
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func getDays() {
        days = [TrainingDay]()
        db.collection("users").document(username!).collection("seasons").document(seasonName!).collection("weeks").document("Week \(weekName!)").collection("days").getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print(document.documentID)
                    let dayName = document.documentID
                    let amMileage = document.data()["AM Mileage"] as! Int
                    let pmMileage = document.data()["PM Mileage"] as! Int
                    let easyDay = document.data()["Easy Day?"] as! Bool
                    let workoutDay = document.data()["Workout Day?"] as! Bool
                    let raceDay = document.data()["Race Day?"] as! Bool
                    let longRun = document.data()["Long Run?"] as! Bool
                    let notes = document.data()["Notes"] as! String
                    
                    self.days.append(TrainingDay(amMileage: amMileage, pmMileage: pmMileage, dayOfMonth: "1", dayName: dayName, easy: easyDay, workout: workoutDay, race: raceDay, longRun: longRun, notes: notes))
                    DispatchQueue.main.async {
                            self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            if id == "detailSegue" {
                if let detailTVC = segue.destination as? TrainingDetailsTableViewController {
                    if let indexPath = tableView.indexPathForSelectedRow {
                        let day = days[indexPath.row]
                        print(day.easy)
                        detailTVC.day = day
                    }
                }
            }
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
