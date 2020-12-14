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
        cell.detailTextLabel?.text = "\(season.mileage)"

        return cell
    }
    
    func getSeasons() {
        seasons = [Season]()
        db.collection("users").document("lukesamuelmason@gmail.com").collection("seasons").order(by: "object.start date").getDocuments{ (querySnapshot, err) in
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
