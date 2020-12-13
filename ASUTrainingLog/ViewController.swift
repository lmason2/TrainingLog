//
//  ViewController.swift
//  ASUTrainingLog
//
//  Created by Luke Mason on 12/1/20.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class ViewController: UIViewController {
    
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    
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
                
                // Add a new document with a generated ID
                var ref: DocumentReference? = nil
                ref = strongSelf.db.collection("users").addDocument(data: [
                    "username": strongSelf.emailTF.text!
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID: \(ref!.documentID)")
                    }
                }
            })
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in}))
        present(alert, animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
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
}

