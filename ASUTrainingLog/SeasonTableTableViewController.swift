//
//  SeasonTableTableViewController.swift
//  ASUTrainingLog
//
//  Created by Luke Mason on 12/5/20.
//

import UIKit
import Firebase
import FirebaseFirestore

class SeasonTableTableViewController: UITableViewController {
    
    var username: String?
    var seasons = [Season]()
    var db: Firestore!
    
    @IBAction func editButtonPressed(sender: UIBarButtonItem) {
        let newEditingMode = !tableView.isEditing
        tableView.setEditing(newEditingMode, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        getSeasons()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return seasons.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let season = seasons[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "simpleSub", for: indexPath)

        cell.textLabel?.text = "\(season.name)"
        cell.detailTextLabel?.text = "Mileage: \(season.mileage)"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        showDeleteAlert(indexPath: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            if id == "seasonToWeekSegue" {
                if let weekTVC = segue.destination as? WeeklyTableViewController {
                    if let indexPath = tableView.indexPathForSelectedRow {
                        let season = seasons[indexPath.row]
                        weekTVC.seasonName = season.name
                        weekTVC.username = self.username
                    }
                }
            }
        }
    }
    
    func showDeleteAlert(indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Are You Sure?", message: "If you delete this season the data associated will also be deleted.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Yes, Delete.", style: .default, handler: { (action) -> Void in
            let seasonName = self.seasons[indexPath.row].name
            self.db.collection("users").document(self.username!).collection("seasons").document(seasonName).delete() { err in
                if let err = err {
                    print("Error removing season: \(err)")
                } else {
                    print("Season successfully removed!")
                    self.seasons.remove(at: indexPath.row)
                    DispatchQueue.main.async {
                        self.tableView.isEditing = false
                        self.tableView.reloadData()
                    }
                }
            }
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func getSeasons() {
        seasons = [Season]()
        db.collection("users").document(username!).collection("seasons").order(by: "object.start date").getDocuments{ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let dictionaryOptional = document.data()["object"] as? NSDictionary
                    if let dictionary = dictionaryOptional {
                        let name = document.documentID
                        let startTS = dictionary["start date"] as? Timestamp
                        let endTS = dictionary["end date"] as? Timestamp
                        let startDate = startTS?.dateValue()
                        let endDate = endTS?.dateValue()
                        let mileage = dictionary["mileage"] as? Int
                        self.seasons.append(Season(name: name, start: startDate!, end: endDate!, mileage: mileage!))
                        DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                    }
                }
            }
        }
    }
    
    @IBAction func unwindToSeasonTableView(for segue: UIStoryboardSegue) {
        getSeasons()
    }
}
