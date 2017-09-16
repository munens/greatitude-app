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
    
    @IBOutlet weak var signUpStackView: UIStackView!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordConfirmationField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    var user: User!
    
    var API_URL = "https://infinite-wildwood-35465.herokuapp.com"
    //var API_URL = "http://localhost:5000"
    
    let desc = NSEntityDescription.entity(forEntityName: "User", in: context)
    
    let signupManager = FBSDKLoginManager()
    
    let MyKeyChainWrapper = KeychainWrapper()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        firstNameField.delegate = self
        lastNameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        passwordConfirmationField.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let facebookSignupBtn = UIButton()
     
        if UIDevice.current.userInterfaceIdiom == .phone {
            facebookSignupBtn.frame.size = CGSize(width: 170, height: 30)
            facebookSignupBtn.center = CGPoint(x: self.view.frame.width/2, y: signUpStackView.frame.origin.y + 55)
            facebookSignupBtn.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 14)
        } else {
            facebookSignupBtn.frame.size = CGSize(width: 200, height: 35)
            facebookSignupBtn.center = CGPoint(x: self.view.frame.width/2, y: signUpStackView.frame.origin.y + 70)
            facebookSignupBtn.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 17)
        }
        
        facebookSignupBtn.backgroundColor = UIColor.init(red: 59, green: 89, blue: 152, alpha: 0)
        
        facebookSignupBtn.layer.borderWidth = 1.0
        facebookSignupBtn.layer.borderColor = UIColor.white.cgColor
        facebookSignupBtn.layer.cornerRadius = 3
        
        facebookSignupBtn.setTitle("Sign up with facebook", for: .normal)
        facebookSignupBtn.addTarget(self, action: #selector(SignUpVC.facebookSignupBtnClicked), for: .touchUpInside)
        //facebookSignupBtn.addTarget(self, action: self.facebookSignupBtnClicked, for: .touchUpInside)
        view.addSubview(facebookSignupBtn)
        
        backBtn.setTitleColor(UIColor.white, for: .normal)
        backBtn.layer.borderColor = UIColor.white.cgColor
        backBtn.layer.borderWidth = 1.0
        backBtn.layer.cornerRadius = 3
        backBtn.setTitleColor(UIColor.white, for: .normal)
        backBtn.layer.borderColor = UIColor.white.cgColor
        
        signUpBtn.layer.borderWidth = 1.0
        signUpBtn.layer.cornerRadius = 3
        disableSignUpBtn()
        
        signUpBtn.isUserInteractionEnabled = false
        signUpBtn.isEnabled = false
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
    
    func enableSignUpBtn(){
        let enabledColor = UIColor.white
        signUpBtn.setTitleColor(enabledColor, for: .normal)
        signUpBtn.layer.borderColor = enabledColor.cgColor
        signUpBtn.isUserInteractionEnabled = true
        signUpBtn.isEnabled = true
    }
    
    func disableSignUpBtn(){
        let disabledColor = UIColor.white.withAlphaComponent(CGFloat(0.5))
        signUpBtn.setTitleColor(disabledColor, for: .normal)
        signUpBtn.layer.borderColor = disabledColor.cgColor
        signUpBtn.isUserInteractionEnabled = false
        signUpBtn.isEnabled = false
    }
    
    func displaySignUpErrorAlert(){
        let alertController = UIAlertController(title: "Sign up error", message: "There appears to be an error. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(alert: UIAlertAction) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func openQuestionVC(user: User){
        DispatchQueue.main.sync(execute: {
            let questionVC = self.storyboard?.instantiateViewController(withIdentifier: "QuestionVC") as! QuestionVC
            questionVC.selectedUser = user
            self.present(questionVC, animated: true, completion: nil)
        })
    }
    
    @objc func facebookSignupBtnClicked() {
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
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            checkUserInDB(uuid: uuid) { error, data in
                let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email"])
                let connection = FBSDKGraphRequestConnection()
                
                connection.add(graphRequest, completionHandler: { (connection, result, error) -> Void in
                    
                    if(error != nil){
                        
                        print("munesh: error with graph request \(String(describing: error))")
                        connection?.cancel()
                        self.signupManager.logOut()
                        
                    } else {
                        
                        let user = User(entity: self.desc!, insertInto: context)
                        print("fetched user : \(String(describing: result))")
                        
                        user.uuid = uuid
                        
                        if let firstname = (result as AnyObject).value(forKey: "first_name") {
                            user.firstname = firstname as? String
                        }
                        
                        if let lastname = (result as AnyObject).value(forKey: "last_name") {
                            user.lastname = lastname as? String
                        }
                        
                        if let email = (result as AnyObject).value(forKey: "email") {
                            user.email = email as? String
                        }
                        
                        user.password = ""
                        
                        ad.saveContext()
                        
                        if data! {
                            self.updateUser(user: user, uuid:  uuid, type: "login")
                        } else {
                            self.saveUser(user: user, type: "login")
                        }
                        connection?.cancel()
                    }
                })
                
                connection.start()
            }
            
        } else {
            signupManager.logOut()
            print("unable to get the phone uuid")
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        //let welcomeVC = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
        //self.present(welcomeVC, animated: true, completion: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        disableSignUpBtn()
        if CheckInternetConnection.isConnected() {
            if let uuid = UIDevice.current.identifierForVendor?.uuidString {
                checkUserInDB(uuid: uuid) { error, data in
                    
                    if error != nil {
                        print("database error: \(String(describing: error))")
                        return
                    }
                    
                    var user = self.user
                    user = User(entity: self.desc!, insertInto: context)
                    
                    user?.uuid = uuid
                    
                    if let firstname = self.firstNameField.text {
                        user?.firstname = firstname
                    }
                    
                    if let lastname = self.lastNameField.text {
                        user?.lastname = lastname
                    }
                    
                    if let email = self.emailField.text {
                        user?.email = email
                    }
                    
                    if let password = self.passwordField.text {
                        user?.password = password
                    }
                    
                    if(user?.firstname != "" && user?.lastname != "" && user?.email != "" && user?.password != ""){
                        ad.saveContext()
                        if data! {
                            self.updateUser(user: user!, uuid:  uuid, type: "user")
                        } else {
                            self.saveUser(user: user!, type: "user")
                        }
                        
                    } else {
                        self.displaySignUpErrorAlert()
                    }
                }
            } else {
                enableSignUpBtn()
                displaySignUpErrorAlert()
                print("unable to get the phone uuid")
            }
        } else {
            enableSignUpBtn()
            let alertController = UIAlertController(title: "No Internet Connection", message: "This application requires an internet connection to complete sign up.", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(alert: UIAlertAction) in
                alertController.dismiss(animated: true, completion: nil)
            }))
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func checkUserInDB(uuid: String, dataHandler: @escaping (NSError?, Bool?) -> Void) {
        
        let url: NSURL = NSURL(string: API_URL +  "/api/user/" + uuid)!
        var request = URLRequest(url: url as URL)
        
        request.httpMethod = "GET"
        
        // to solve at later time:
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
    
    func saveUser(user: User, type: String){
        saveUserInDB(user: user) { error, user in
            if error != nil {
                print(error!)
                return
            } else if user != nil {
                if type == "user" {
                    self.addUserToKeyChain(uuid: (user?.uuid!)!, email: (user?.email!)!, password: (user?.password!)!)
                }
                self.openQuestionVC(user: user!)
            }
        }
    }
    
    func saveUserInDB(user: User, completionHandler: @escaping (NSError?, User?) -> Void){
        
        let url: NSURL = NSURL(string: API_URL + "/api/users")!
        var request = URLRequest(url: url as URL)
        
        request.httpMethod = "POST"
        
        let postParams = "uuid=" + user.uuid! + "&firstname=" + user.firstname! + "&lastname=" + user.lastname! + "&email=" + user.email! + "&password=" + user.password!
        request.httpBody = postParams.data(using: String.Encoding.utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                print(error!)
                completionHandler(error! as NSError, nil)
                return;
            }
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let json = jsonResponse {
                    print("jsonResponse saveUserInDB : \(json)")
                    ((json["results"] as! NSArray) as Array).isEmpty ? completionHandler(nil, nil) : completionHandler(nil, user)
                }
                
            } catch {
                completionHandler(error as NSError, nil)
                print(error)
            }
            
        }
        task.resume()
    }
    
    
    func updateUser(user: User, uuid: String, type: String){
        updateUserInDB(user: user, uuid: uuid) { error, user in
            if error != nil {
                print(error!)
                return
            } else if(user != nil) {
                if type == "user" {
                    self.addUserToKeyChain(uuid: (user?.uuid!)!, email: (user?.email!)!, password: (user?.password!)!)
                }
                self.openQuestionVC(user: user!)
            }
        }
    }
    
    func updateUserInDB(user: User, uuid: String, completionHandler: @escaping (NSError?, User?) -> Void){
        let url: NSURL = NSURL(string: API_URL + "/api/user")!
        var request = URLRequest(url: url as URL)
        
        request.httpMethod = "POST"
        
        let putParams = "uuid=" + user.uuid! + "&firstname=" + user.firstname! + "&lastname=" + user.lastname! + "&email=" + user.email! + "&password=" + user.password!
        
        //let putParams:[String: String] = ["uuid": user.uuid!, "firstname": user.firstname!, "lastname": user.lastname!, "email": user.email!, "password": user.password!, "prevuuid": uuid ]
        //request.httpBody = try JSONSerialization.data(withJSONObject: putParams, options: JSONSerialization.WritingOptions())
        
        request.httpBody = putParams.data(using: String.Encoding.utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                print(error!)
                completionHandler(error! as NSError, nil)
                return;
            }
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let json = jsonResponse {
                    print("jsonResponse updateUserInDB : \(json)")
                    ((json["results"] as! NSArray) as Array).isEmpty ? completionHandler(nil, nil) : completionHandler(nil, user)
                }
                
            } catch {
                completionHandler(error as NSError, nil)
                print(error)
            }
        }
        task.resume()
    }
    
    func addUserToKeyChain(uuid: String, email: String, password: Any) -> Void {
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
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("password fields are being editted \(passwordConfirmationField.isEditing) , \(passwordField.text == passwordConfirmationField.text)")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if passwordField.text != passwordConfirmationField.text && passwordConfirmationField.text != "" {
            createPasswordUnMatchOverlay()
        }
        
        if(passwordField.text == passwordConfirmationField.text && passwordField.text != "" && passwordConfirmationField.text != "" && firstNameField.text != "" && lastNameField.text != "" && emailField.text != ""
            ){
            enableSignUpBtn()
        } else {
            disableSignUpBtn()
        }
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true;
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true;
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if emailField.isEditing {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            let validation = emailTest.evaluate(with: emailField.text)
            if(validation == false){
                emailField.layer.borderColor = UIColor.red.cgColor
                emailField.layer.borderWidth = 1
                emailField.placeholder = "Email should be in the correct format."
                createInvalidEmailOverlay()
                
            } else {
                emailField.layer.borderWidth = 0
                emailField.placeholder = ""
            }
            return validation
        }
        return true
    }
    
    func createPasswordUnMatchOverlay() {
        let deadlineTime = DispatchTime.now() + .seconds(4)
        let window = UIApplication.shared.keyWindow!
        
        let rectangleView = UIView(frame: CGRect(x:0, y:30, width: self.view.frame.size.width, height: 20))
        rectangleView.backgroundColor = UIColor.red
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20))
        label.text = "passwords do not match"
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        
        rectangleView.addSubview(label)
        window.addSubview(rectangleView)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            rectangleView.removeFromSuperview()
        }
    }
    
    func createInvalidEmailOverlay() {
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
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        return true
    }
    
}
