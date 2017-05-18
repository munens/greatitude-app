//
//  LoginVC.swift
//  natalie-app-2
//
//  Created by Kuzivakwashe Mutonga on 2017-04-12.
//  Copyright © 2017 Munene Kaumbutho - Evan Zhang. All rights reserved.
//

import UIKit
import CoreData

class LoginVC: UIViewController, NSFetchedResultsControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var controller: NSFetchedResultsController<User>!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        emailField.delegate = self
        
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
            performSegue(withIdentifier: "QuestionVC", sender: user)
        } else {
            emailField.text = ""
            passwordField.text = ""
            createAuthenticationOverlay()
            //dismiss(animated: true, completion: nil)
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
    
    func createAuthenticationOverlay(){
        let deadlineTime = DispatchTime.now() + .seconds(5)
        let window = UIApplication.shared.keyWindow!
        
        let rectangleView = UIView(frame: CGRect(x:0, y:30, width: self.view.frame.size.width, height: 20))
        rectangleView.backgroundColor = UIColor.red
        
        let label = UILabel(frame: CGRect(x:0, y:0, width: self.view.frame.size.width, height: 20))
        label.text = "The email or password combination is incorrect"
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        
        rectangleView.addSubview(label)
        
        window.addSubview(rectangleView)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            rectangleView.removeFromSuperview()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let questionVC = segue.destination as? QuestionVC else { return }
        if let user = sender as? User {
            questionVC.selectedUser = user
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true;
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true;
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let validation = emailTest.evaluate(with: emailField.text)
        if(validation == false){
            emailField.layer.borderColor = UIColor.red.cgColor
            emailField.layer.borderWidth = 1
            emailField.placeholder = "Email should be in the correct format."
            createOverlay()
        } else {
            emailField.layer.borderWidth = 0
            emailField.placeholder = ""
        }
        return validation;
    }
    
    func createOverlay() {
        let deadlineTime = DispatchTime.now() + .seconds(4)
        let window = UIApplication.shared.keyWindow!
        
        let rectangleView = UIView(frame: CGRect(x:0, y:30, width: self.view.frame.size.width, height: 20))
        rectangleView.backgroundColor = UIColor.red
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20))
        label.text = "email is in invalid format"
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        
        rectangleView.addSubview(label)
        window.addSubview(rectangleView)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            rectangleView.removeFromSuperview()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true;
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        return true
    }
    
}
