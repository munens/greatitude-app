//
//  SignUpVC.swift
//  natalie-app-2
//
//  Created by Kuzivakwashe Mutonga on 2017-04-11.
//  Copyright © 2017 Munene Kaumbutho - Evan Zhang. All rights reserved.
//

import UIKit
import CoreData

class SignUpVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordConfirmationField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var user: User!
    
    let desc = NSEntityDescription.entity(forEntityName: "User", in: context)
    
    
    
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
                performSegue(withIdentifier: "QuestionVC", sender: user)
            }
        } else {
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let questionVC = segue.destination as? QuestionVC else { return }
//        if let user = sender as? User {
//            questionVC.selectedUser = user
//        }
        print(sender!)
        
        if segue.identifier == "QuestionVC" {
            if let questionVC = segue.destination as? QuestionVC {
                if let user = sender as? User {
                    print(user)
                    questionVC.selectedUser = user
                }
            }
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
