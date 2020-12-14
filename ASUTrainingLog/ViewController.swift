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

class ViewController: UIViewController {
    
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    
    var ref: DatabaseReference!
    var db: Firestore!

    @IBAction func logInButtonTapped(_ sender: UIButton) {
        guard let email = emailTF.text, email != "",
              let password = passwordTF.text, password != "" else {
            return
        }
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] result, error  in
            guard let strongSelf = self else {
                return
            }
            guard error == nil else {
                // show account creation
                strongSelf.showCreateAccount(email: email, password: password)
                return
            }
            strongSelf.performSegue(withIdentifier: "loginSegue", sender: strongSelf)
        })
    }
    
    
    func showCreateAccount(email: String, password: String) {
        let alert = UIAlertController(title: "Create Account", message: "Would you like to create an account?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: {_ in
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self] result, error in
                guard let strongSelf = self else {
                    return
                }
                guard error == nil else {
                    // show account creation
                    return
                }
                
                strongSelf.performSegue(withIdentifier: "loginSegue", sender: strongSelf)
                
                // Add a new document in collection
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
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
        let settings = FirestoreSettings()

        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        if FirebaseAuth.Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "loginSegue", sender: self)
        }
    }
    
    @IBAction func logoutUnwind(for segue: UIStoryboardSegue) {
        emailTF.text = ""
        passwordTF.text = ""
        do {
            try FirebaseAuth.Auth.auth().signOut()
        }
        catch {
            print("An error occurred")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            if id == "loginSegue" {
                if let todaysTrainingVC = segue.destination as? TodaysTrainingViewController {
                    todaysTrainingVC.username = emailTF.text!
                }
            }
        }
    }
}

