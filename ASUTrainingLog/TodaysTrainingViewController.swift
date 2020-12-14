//
//  TodaysTrainingViewController.swift
//  ASUTrainingLog
//
//  Created by Luke Mason on 12/3/20.
//

import UIKit
import Firebase

// Class to show the user the home screen of the application
class TodaysTrainingViewController: UIViewController {
    
    var username: String? // The user's username

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let _ = username else {
            // The username is set from the previous controller
            return
        }
        // Set the username from authorization
        username = Firebase.Auth.auth().currentUser?.email
        
        // Hide back button
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    /*
     * Function to support unwinding segues
     */
    @IBAction func unwindToTdaysTrainingVC(for segue: UIStoryboardSegue) {
    }
    
    /*
     * Function to prepare for segues to other controllers
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            if id == "newEntrySegue" {
                // User wants to add training
                if let newEntryTVC = segue.destination as? NewEntryTableViewController {
                    // Set username
                    newEntryTVC.username = username
                }
            }
            else if id == "seasonsSegue" {
                // User wants to view previous seasons
                if let seasonsTVC = segue.destination as? SeasonTableTableViewController {
                    // Set username
                    seasonsTVC.username = username
                }
            }
        }
    }
}
