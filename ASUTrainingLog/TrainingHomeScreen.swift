//
//  TrainingHomeScreen.swift
//  ASUTrainingLog
//
//  Created by Luke Mason on 12/1/20.
//

import UIKit
import FirebaseAuth

class TrainingHomeScreen: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIBarButtonItem) {
        do {
           try FirebaseAuth.Auth.auth().signOut()
        }
        catch {
            print("An error occurred")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
