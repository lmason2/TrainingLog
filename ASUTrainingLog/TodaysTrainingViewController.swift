//
//  TodaysTrainingViewController.swift
//  ASUTrainingLog
//
//  Created by Luke Mason on 12/3/20.
//

import UIKit
import Firebase

class TodaysTrainingViewController: UIViewController {
    
    var username: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let _ = username else {
            return
        }
        username = Firebase.Auth.auth().currentUser?.email
        // Do any additional setup after loading the view.
    }
    
    @IBAction func unwindToTdaysTrainingVC(for segue: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            if id == "newEntrySegue" {
                if let newEntryTVC = segue.destination as? NewEntryTableViewController {
                    newEntryTVC.username = username
                }
            }
            else if id == "seasonsSegue" {
                if let seasonsTVC = segue.destination as? SeasonTableTableViewController {
                    seasonsTVC.username = username
                }
            }
        }
    }

}
