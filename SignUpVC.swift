//
//  SignUpVC.swift
//  natalie-app-2
//
//  Created by Kuzivakwashe Mutonga on 2017-04-11.
//  Copyright © 2017 Munene Kaumbutho - Evan Zhang. All rights reserved.
//

import UIKit
import CoreData

class SignUpVC: UIViewController {

    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordConfirmationField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }

//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        
        var user:User!
        
        //let desc:NSEntityDescription? = NSEntityDescription.entity(forEntityName: "user", in: context)
        
        let desc = NSEntityDescription.entity(forEntityName: "User", in: context)
        
        user =  User(entity: desc!, insertInto: context)
        
        if let firstname = firstNameField.text {
            user.firstname = firstname
        }

        if let lastname = lastNameField.text {
            user.lastname = lastname
        }
        
        if let email = emailField.text {
            user.email = email
        }
       
        if let password = passwordField.text {
            user.password = password
        }
        print(user)
        if(user.firstname != "" && user.lastname != "" && user.email != "" && user.password != ""){
            ad.saveContext()
            performSegue(withIdentifier: "MainVC", sender: user)
        } else {
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as?
            MainVC {
            
            if let user = sender as? User {
                destination.selectedUser = user
            }
        }
    }

}
