//
//  ViewController.swift
//  ASUTrainingLog
//
//  Created by Luke Mason on 12/1/20.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

// Class to handle login to application
class ViewController: UIViewController {
    
    @IBOutlet var emailTF: UITextField! // Text field for user's email
    @IBOutlet var passwordTF: UITextField! // Text field for user's password
    
    var db: Firestore! // Reference to Firestore database

    /*
     * Action call back for login button
     */
    @IBAction func logInButtonTapped(_ sender: UIButton) {
        // Check fields are filled
        guard let email = emailTF.text, email != "",
              let password = passwordTF.text, password != "" else {
            return
        }
        // Firebase sign in
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] result, error  in
            guard let strongSelf = self else {
                return
            }
            guard error == nil else {
                // Show account creation option for new account
                strongSelf.showCreateAccount(email: email, password: password)
                return
            }
            // Log in
            strongSelf.performSegue(withIdentifier: "loginSegue", sender: strongSelf)
        })
    }
    
    /*
     * Function to show alert to create account
     * params: email - user's email
     *         pssword - user's password
     */
    func showCreateAccount(email: String, password: String) {
        // Show alert
        let alert = UIAlertController(title: "Create Account", message: "Would you like to create an account?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: {_ in
            // Add user
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self] result, error in
                guard let strongSelf = self else {
                    return
                }
                guard error == nil else {
                    return
                }
                
                // Log in
                strongSelf.performSegue(withIdentifier: "loginSegue", sender: strongSelf)
                
                // Add a new document in users collection for user
                strongSelf.db.collection("users").document(strongSelf.emailTF.text!).setData(["seasons" : "none"]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                    }
                }
            })
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in}))
        present(alert, animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up Firestore cloud storage
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        if FirebaseAuth.Auth.auth().currentUser != nil {
            // If user is logged in, skip log in screen
            performSegue(withIdentifier: "loginSegue", sender: self)
        }
    }
    
    /*
     * Unwind function for logout
     */
    @IBAction func logoutUnwind(for segue: UIStoryboardSegue) {
        // Clear text fields
        emailTF.text = ""
        passwordTF.text = ""
        do {
            // Log user out
            try FirebaseAuth.Auth.auth().signOut()
        }
        catch {
            print("An error occurred")
        }
    }
    
    /*
     * Function to prepare for log in
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            if id == "loginSegue" {
                // Cast destination controller
                if let todaysTrainingVC = segue.destination as? TodaysTrainingViewController {
                    // Set username to user's email
                    todaysTrainingVC.username = emailTF.text!
                }
            }
        }
    }
}

