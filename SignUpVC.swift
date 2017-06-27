//
//  SignUpVC.swift
//  natalie-app-2
//
//  Created by Kuzivakwashe Mutonga on 2017-04-11.
//  Copyright © 2017 Munene Kaumbutho - Evan Zhang. All rights reserved.
//

import UIKit
import CoreData
import FBSDKCoreKit
import FBSDKLoginKit

class SignUpVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordConfirmationField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var user: User!
    
    let desc = NSEntityDescription.entity(forEntityName: "User", in: context)
    
    let MyKeyChainWrapper = KeychainWrapper()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        emailField.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let facebookSignupBtn = UIButton(frame: CGRect(x: 40, y: 100, width: 200, height: 45))
        facebookSignupBtn.backgroundColor = UIColor.init(red: 59, green: 89, blue: 152, alpha: 0)
        
        facebookSignupBtn.setTitle("Sign up with facebook", for: .normal)
        facebookSignupBtn.addTarget(self, action: #selector(SignUpVC.facebookSignupBtnClicked), for: .touchUpInside)
        //facebookSignupBtn.addTarget(self, action: self.facebookSignupBtnClicked, for: .touchUpInside)
        view.addSubview(facebookSignupBtn)
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func facebookSignupBtnClicked() {
        let signupManager = FBSDKLoginManager()
            
        signupManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if error != nil {
                print("munesh: unable to authenticate with facebook: \(String(describing: error))")
            } else if result?.isCancelled == true {
                print("munesh: authentication has been cancelled")
            } else {
                print("munesh: Successful authentication with facebook")
                print("munesh: \(String(describing: result))")
                self.returnUserData()
            }
        }
    
    }
    
    func returnUserData() {
        
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email"])
        graphRequest?.start(completionHandler: { (connection, result, error) -> Void in
            if(error != nil){
                print("munesh: error with graph request \(String(describing: error))")
                connection?.cancel()
            } else {
                let user = User(entity: self.desc!, insertInto: context)
                print("fetched user : \(String(describing: result))")
                //print("fetched user email: \((result as AnyObject).value(forKey: "email"))")
                
                if let firstname = (result as AnyObject).value(forKey: "first_name") {
                    user.firstname = firstname as? String
                }
                
                
                if let lastname = (result as AnyObject).value(forKey: "last_name") {
                    user.lastname = lastname as? String
                }
                
                if let email = (result as AnyObject).value(forKey: "email") {
                    user.email = email as? String
                }
                
                // addUserToKeyChain(email: user.email!, password: nil)
                
                ad.saveContext()
                //self.performSegue(withIdentifier: "QuestionVC", sender: user)
                
                let questionVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QuestionVC") as! QuestionVC
                questionVC.selectedUser = user
                self.present(questionVC, animated: true, completion: nil)
                connection?.cancel()
                
            }
        
        })
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        
        user = User(entity: desc!, insertInto: context)
        
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

        if(user.firstname != "" && user.lastname != "" && user.email != "" && user.password != ""){
            ad.saveContext()
            if(user != nil){
                let questionVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QuestionVC") as! QuestionVC
                
                questionVC.selectedUser = user
                print(user)
                addUserToKeyChain(email: user.email!, password: user.password!)
                //performSegue(withIdentifier: "QuestionVC", sender: user)
                self.present(questionVC, animated: true, completion: nil)
            }
        } else {
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    func addUserToKeyChain(email: String, password: Any) -> Void {
        let hasLoginKey = UserDefaults.standard.bool(forKey: "hasLoginKey")
        if hasLoginKey == false {
            UserDefaults.standard.setValue(email, forKey: "email")
        }
        
        MyKeyChainWrapper.mySetObject(password, forKey: kSecValueData)
        MyKeyChainWrapper.writeToKeychain()
        UserDefaults.standard.set(true, forKey: "hasLoginKey")
        UserDefaults.standard.synchronize()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let questionVC = segue.destination as? QuestionVC else { return }
        if let user = sender as? User {
            questionVC.selectedUser = user
        }

//        if segue.identifier == "QuestionVC" {
//            if let questionVC = segue.destination as? QuestionVC {
//                if let user = sender as? User {
//                    print(user)
//                    questionVC.selectedUser = user
//                }
//            }
//        }
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
