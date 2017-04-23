//
//  LoginVC.swift
//  natalie-app-2
//
//  Created by Kuzivakwashe Mutonga on 2017-04-12.
//  Copyright © 2017 Munene Kaumbutho - Evan Zhang. All rights reserved.
//

import UIKit
import CoreData

class LoginVC: UIViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var controller: NSFetchedResultsController<User>!
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func loginPressed(_ sender: Any) {
        let email = emailField.text
        let password = passwordField.text
        let user = authenticateUser(email: email, password: password)
        if (user != nil) {
            performSegue(withIdentifier: "MainVC", sender: user)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func authenticateUser(email: String?, password: String?) -> Any? {
        //let predicate = NSPredicate (format: "email = %@", email!)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        //fetchRequest.predicate = predicate
        //var error:NSError? = nil
        
        //var fetchResult = ad.managedObjectContext?.executeFetchRequest(fetchRequest, error: &error)
        do {
            let result = try context.fetch(fetchRequest)
            print(result)
            let users:[User] = result as! [User]
            
            for user in users {
                if user.email == email && user.password == password {
                    return user;
                }
            }
            return nil;
        } catch {
            print("\(error)")
            return nil;
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
    
//    func attemptFetch() {
//        
//        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
//        let dateSort = NSSortDescriptor(key: "created_at", ascending: false)
//        
//        fetchRequest.sortDescriptors = [dateSort]
//        
//        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
//        
//        do {
//            try controller.performFetch()
//            
//        } catch {
//            
//            let error = error as NSError
//            print("\(error)")
//        }
//    }
//
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath? ) {
//        
//    }
    
}
