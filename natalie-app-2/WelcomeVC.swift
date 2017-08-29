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
    
    let desc = NSEntityDescription.entity(forEntityName: "User", in: context)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if(FBSDKAccessToken.current() != nil) {
            self.returnUserData()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let hasLoginKey = UserDefaults.standard.bool(forKey: "hasLoginKey")
        if hasLoginKey == true {
            
            if let email = UserDefaults.standard.object(forKey: "email") {
                
                if let user =  getUser(email: email as! String) {
                    performSegue(withIdentifier: "QuestionVC", sender: user)
                }
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func guestBtnPressed(_ sender: Any) {
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            let userFomDB = checkUserInDB(uuid: uuid)
            
            if userFomDB != nil {
                let questionVC = storyboard?.instantiateViewController(withIdentifier: "QuestionVC") as! QuestionVC
                questionVC.selectedUser = userFomDB as! User
                self.present(questionVC, animated: true, completion: nil)
            } else {
                user = User(entity: desc!, insertInto: context)
                
                user.uuid = uuid
                ad.saveContext()
                
                saveUserInDB(user: user)
                
                let questionVC = storyboard?.instantiateViewController(withIdentifier: "QuestionVC") as! QuestionVC
                questionVC.selectedUser = userFomDB as! User
                self.present(questionVC, animated: true, completion: nil)
            }
        } else {
            print("unable to get the phone uuid")        }
    }
    
    func saveUserInDB(user: User){
        /*
         
         // TBD:
         let url: NSURL = NSURL(string: "http://www.livetalent.ca/api/natapp.php")!
         var request = URLRequest(url: url as URL)
         
         request.httpMethod = "POST"
         
         // to solve at later time:
         let postParams = "email="+selectedUser.email!
         request.httpBody = postParams.data(using: String.Encoding.utf8)
         
         let session = URLSession.shared
         let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
         
         if error != nil {
         print(error!)
         return;
         }
         
         do {
         let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
         
         if let json = jsonResponse {
         print(json)
         }
         
         } catch {
         print(error)
         }
         
         })
         task.resume()
         */
    }
    
    func checkUserInDB(uuid: String) -> Any {
        /*
         
         // TBD:
         let url: NSURL = NSURL(string: "http://www.livetalent.ca/api/natapp.php")!
         var request = URLRequest(url: url as URL)
         
         request.httpMethod = "GET"
         
         // to solve at later time:
         let getParams = "uuid="+uuid
         request.httpBody = getParams.data(using: String.Encoding.utf8)
         
         let session = URLSession.shared
         let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
         
         if error != nil {
         print(error!)
         return;
         }
         
         do {
         let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
         
         if let json = jsonResponse {
         // return the user from jsonResponse
         }
         
         } catch {
         print(error)
         }
         
         })
         task.resume()
         */
        
        return false
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

