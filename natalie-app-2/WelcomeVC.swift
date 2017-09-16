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
    
    var API_URL = "https://infinite-wildwood-35465.herokuapp.com"
    //var API_URL = "http://localhost:5000"
    
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
                
                if let user = getUser(email: email as! String) {
                    performSegue(withIdentifier: "QuestionVC", sender: user)
                }
            }
            
        }
    }
    
    @IBAction func SignUpBtnPressed(_ sender: Any) {
        let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        present(signUpVC, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openQuestionVC(user: User) {
        DispatchQueue.main.sync(execute: {
            let questionVC = self.storyboard?.instantiateViewController(withIdentifier: "QuestionVC") as! QuestionVC
            questionVC.selectedUser = user
            self.present(questionVC, animated: true, completion: nil)
        })
    }
    
    @IBAction func guestBtnPressed(_ sender: Any) {
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            self.user = User(entity: self.desc!, insertInto: context)
            checkGuestInDB(uuid: uuid) {error, data in
                
                if error != nil {
                    print("database error: \(String(describing: error))")
                    return
                }
                
                if data! {
                    self.openQuestionVC(user: self.user!)
                } else {
                    self.user.uuid = uuid
                    ad.saveContext()
                    self.saveGuest(user: self.user)
                }
            }
        } else {
            print("unable to get the phone uuid")
        }
    }
    
    func checkGuestInDB(uuid: String, dataHandler: @escaping (NSError?, Bool?) -> Void) {
        
        let url: NSURL = NSURL(string: API_URL +  "/api/guest/" + uuid)!
        var request = URLRequest(url: url as URL)
        
        request.httpMethod = "GET"
        
        //let getParams = "uuid="+uuid
        //request.httpBody = getParams.data(using: String.Encoding.utf8)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                print(error!)
                dataHandler(error! as NSError, false)
                return;
            }
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let json = jsonResponse {
                    print(json)
                    let res = json["results"] as! NSArray
                    dataHandler(nil, !(res as Array).isEmpty)
                }
                
            } catch {
                print(error)
                dataHandler(error as NSError, false)
            }
            
        }
        
        task.resume()
    }
    
    
    func saveGuest(user: User) {
        saveGuestInDB(user: user) { error, results in
            
            if error != nil {
                print("database error: \(String(describing: error))")
                return
            } else if  results != nil {
                print("user been saved: \(String(describing: results!))")
                self.openQuestionVC(user: user)
            }
        }
    }
    
    func saveGuestInDB(user: User, dataHandler:  @escaping (NSError?, User?) -> Void) {

        let url: NSURL = NSURL(string: API_URL + "/api/guest")!
        var request = URLRequest(url: url as URL)
        
        request.httpMethod = "POST"
        
        // to solve at later time:
        let postParams = "uuid=" + user.uuid!
        request.httpBody = postParams.data(using: String.Encoding.utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                print(error!)
                return;
            }
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let json = jsonResponse {
                    print("jsonResponse: saveGuestInDB")
                    ((json["results"] as! NSArray) as Array).isEmpty ? dataHandler(nil, nil) : dataHandler(nil, user)
                }
                
            } catch {
                print(error)
                dataHandler(error as NSError, nil)
            }
            
        }
        task.resume()
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

