//
//  WeeklyTableViewController.swift
//  ASUTrainingLog
//
//  Created by Luke Mason on 12/13/20.
//

import UIKit
import Firebase
import FirebaseFirestore

class WeeklyTableViewController: UITableViewController {
    
    var weeks = [Week]()
    var seasonName: String?
    var db: Firestore!
    
    @IBAction func editButtonPressed (_ sender: UIBarButtonItem) {
        let newEditingMode = !tableView.isEditing
        tableView.setEditing(newEditingMode, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        getWeeks()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return weeks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "simpleSub", for: indexPath)
        
        let week = weeks[indexPath.row]

        cell.textLabel?.text = "Week \(week.number)"
        cell.detailTextLabel?.text = "Mileage: \(week.mileage)"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        showDeleteAlert()
    }
    
    func showDeleteAlert() {
        let alertController = UIAlertController(title: "Are You Sure?", message: "If you delete this week, all of its associated days and the data associated will also be deleted.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Yes, Delete.", style: .default, handler: { (action) -> Void in
            // Delete associated day in firestore
            // Delete data from tableview
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func getWeeks() {
        weeks = [Week]()
        db.collection("users").document("lukesamuelmason@gmail.com").collection("seasons").document(seasonName!).collection("weeks").getDocuments{ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let weekName = document.documentID
                    let weekNumber = weekName[weekName.index(weekName.endIndex, offsetBy: -1)]
                    let mileage = document.data()["mileage"]
                    self.weeks.append(Week(number: Int(String(weekNumber))!, mileage: mileage as! Int))
                    DispatchQueue.main.async {
                            self.tableView.reloadData()
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
