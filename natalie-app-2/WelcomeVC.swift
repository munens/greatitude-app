//
//  ViewController.swift
//  natalie-app-2
//
//  Created by Kuzivakwashe Mutonga on 2017-04-11.
//  Copyright © 2017 Munene Kaumbutho - Evan Zhang. All rights reserved.
//

import UIKit
import CoreData
import FBSDKCoreKit
import FBSDKLoginKit

class WelcomeVC: UIViewController, NSFetchedResultsControllerDelegate {
    
    var user:User!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if(FBSDKAccessToken.current() != nil) {
            self.returnUserData()
        }
        
        let hasLoginKey = UserDefaults.standard.bool(forKey: "hasLoginKey")
        if hasLoginKey == true {
            let email = UserDefaults.standard.object(forKey: "email")
            print(email)
            user = getUser(email: email as! String) as! User
            if user != nil {
                performSegue(withIdentifier: "QuestionVC", sender: user)
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func returnUserData() {
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "first_name, last_name, email, name"])
        graphRequest?.start(completionHandler: { (connection, result, error) -> Void in
            if error != nil {
                print("munesh: error with graph request \(String(describing: error))")
            } else {
                if let email = (result as AnyObject).value(forKey: "email") {
                    if let user = self.getUser(email: (email as? String)!) {
                        self.performSegue(withIdentifier: "QuestionVC", sender: user)
                    }
                }
            }
        })
    }
    
    func getUser(email: String) -> Any? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        do {
            let result = try context.fetch(fetchRequest)
            let users:[User] = result as! [User]
            
            for user in users {
                if user.email == email {
                    return user
                }
            }
            return nil
        } catch {
            print("\(error)")
            return nil
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let questionVC = segue.destination as? QuestionVC else { return }
        if let user = sender as? User {
            questionVC.selectedUser = user
        }
    }


}

