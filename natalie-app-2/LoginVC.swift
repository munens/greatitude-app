//
//  LoginVC.swift
//  natalie-app-2
//
//  Created by Kuzivakwashe Mutonga on 2017-04-12.
//  Copyright © 2017 Munene Kaumbutho - Evan Zhang. All rights reserved.
//

import UIKit
import CoreData
import FBSDKLoginKit
import FBSDKCoreKit

class LoginVC: UIViewController, NSFetchedResultsControllerDelegate, UITextFieldDelegate, FBSDKLoginButtonDelegate {
    
    var user: User!
    let desc = NSEntityDescription.entity(forEntityName: "User", in: context)
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    var controller: NSFetchedResultsController<User>!
    
    var API_URL = "https://infinite-wildwood-35465.herokuapp.com"
    //var API_URL = "http://localhost:5000"
    
    let MyKeyChainWrapper = KeychainWrapper()

    let loginManager = FBSDKLoginManager()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let facebookLoginBtn = UIButton()
        //facebookSignupBtn.center = CGPoint(x: self.view.frame.width/2, y: signUpStackView.frame.origin.y + 50)
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            facebookLoginBtn.frame.size = CGSize(width: 170, height: 30)
            facebookLoginBtn.center = CGPoint(x: self.view.frame.width/2, y: 120)
            facebookLoginBtn.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 14)
        } else {
            facebookLoginBtn.frame.size = CGSize(width: 200, height: 35)
            facebookLoginBtn.center = CGPoint(x: self.view.frame.width/2, y: 120)
            facebookLoginBtn.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 17)
        }
        
        facebookLoginBtn.backgroundColor = UIColor.init(red: 59, green: 89, blue: 152, alpha: 0)
        
        facebookLoginBtn.layer.borderWidth = 1.0
        facebookLoginBtn.layer.borderColor = UIColor.white.cgColor
        facebookLoginBtn.layer.cornerRadius = 3
        
        facebookLoginBtn.setTitle("continue with facebook", for: .normal)
        facebookLoginBtn.addTarget(self, action: #selector(self.facebookLoginBtnClicked), for: .touchUpInside)
        view.addSubview(facebookLoginBtn)
        
        // Do any additional setup after loading the view.
        emailField.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        backBtn.setTitleColor(UIColor.white, for: .normal)
        backBtn.layer.borderColor = UIColor.white.cgColor
        backBtn.layer.borderWidth = 1.0
        backBtn.layer.borderColor = UIColor.white.cgColor
        backBtn.layer.cornerRadius = 3
        
        loginBtn.layer.borderWidth = 1.0
        loginBtn.layer.borderColor = UIColor.white.cgColor
        loginBtn.layer.cornerRadius = 3
        
        disableLoginBtn()
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("user is logged in")
        
        if(error != nil){
            print("munesh: error with facebook login")
        } else if result.isCancelled {
            print("munesh: User has cancelled login")
        } else {
            print("munesh: success - user has authenticated successfully")
            self.returnUserData()
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User has logged out")
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func enableLoginBtn(){
        let enabledColor = UIColor.white
        loginBtn.setTitleColor(enabledColor, for: .normal)
        loginBtn.layer.borderColor = enabledColor.cgColor
        loginBtn.isUserInteractionEnabled = true
        loginBtn.isEnabled = true
    }
    
    func disableLoginBtn(){
        let disabledColor = UIColor.white.withAlphaComponent(CGFloat(0.5))
        loginBtn.setTitleColor(disabledColor, for: .normal)
        loginBtn.layer.borderColor = disabledColor.cgColor
        loginBtn.isUserInteractionEnabled = false
        loginBtn.isEnabled = false
    }
    
    func displayLoginErrorAlert(){
        let alertController = UIAlertController(title: "Sign up error", message: "There appears to be an error. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(alert: UIAlertAction) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func facebookLoginBtnClicked(){
        loginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
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
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "first_name, last_name, email, name"])
        let connection = FBSDKGraphRequestConnection()
        connection.add(graphRequest, completionHandler: { (connection, result, error) -> Void in
            if error != nil {
                print("munesh: error with graph request \(String(describing: error))")
                connection?.cancel()
            } else {
                if let email = (result as AnyObject).value(forKey: "email") {
                    print("returning user data email")
                    if let user = self.authenticateUser(email: email as? String, password: nil) {

                        self.openQuestionVC(user: user as! User)
                        connection?.cancel()
                        
                    } else {
                        
                        let uuid = UIDevice.current.identifierForVendor?.uuidString
                        self.getUser(uuid: uuid!, email: email as! String, password: "") { error, user in
                            if error != nil {
                                print(error!)
                                self.loginManager.logOut()
                                return
                            }
                            
                            if user != nil {
                                self.openQuestionVC(user: user!)
                            } else {
                                self.loginManager.logOut()
                                self.openWelcomeVC()
                                return
                            }
                        }
                        connection?.cancel()
                    }
                }
            }
        })
        connection.start()
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
    */
    func clearFields() {
        DispatchQueue.main.sync(execute: {
            emailField.text = ""
            passwordField.text = ""
            createAuthenticationOverlay()
            //dismiss(animated: true, completion: nil)
        })
    }
    
    func openWelcomeVC() {
        DispatchQueue.main.sync(execute: {
            let questionVC = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
            self.present(questionVC, animated: true, completion: nil)
        })
    }
    
    func openQuestionVC(user: User){
        DispatchQueue.main.sync(execute: {
            let questionVC = self.storyboard?.instantiateViewController(withIdentifier: "QuestionVC") as! QuestionVC
            questionVC.selectedUser = user
            self.present(questionVC, animated: true, completion: nil)
        })
    }
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        if CheckInternetConnection.isConnected() {
            let email = emailField.text
            let password = passwordField.text
            let user = authenticateUser(email: email, password: password) as? User
            if (user != nil) {
                addUserToKeyChain(uuid: (user?.uuid!)!, email: (user?.email!)!, password: (user?.password)!)
                let questionVC = self.storyboard?.instantiateViewController(withIdentifier: "QuestionVC") as! QuestionVC
                questionVC.selectedUser = user! 
                self.present(questionVC, animated: true, completion: nil)
            } else {
                if let uuid = UIDevice.current.identifierForVendor?.uuidString {
                    getUser(uuid: uuid, email: email!, password: password!) { error, user in
                        if error != nil {
                            print(error!)
                            self.clearFields()
                            return
                        }
                        
                        if user != nil {
                            self.addUserToKeyChain(uuid: (user?.uuid)!, email: (user?.email)!, password: (user?.password)!)
                            self.openQuestionVC(user: user!)
                        } else {
                            self.displayLoginErrorAlert()
                            self.clearFields()
                            return
                        }
                    }
                } else {
                    print("unable to get the phone uuid")
                    displayLoginErrorAlert()
                    self.clearFields()
                }
            }
        } else {
            let alertController = UIAlertController(title: "No Internet Connection", message: "This application requires an internet connection to complete login.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(alert: UIAlertAction) in
                alertController.dismiss(animated: true, completion: nil)
            }))
            present(alertController, animated: true, completion: nil)
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
    
    func getUser(uuid: String, email: String, password: String, completionHandler: @escaping (NSError?, User?) -> Void){
        let url: NSURL = NSURL(string: API_URL +  "/api/login")!
        var request = URLRequest(url: url as URL)
        
        request.httpMethod = "POST"
        
        let postParams = "uuid=" + uuid + "&email=" + email + "&password=" + password
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
                    let res = ((json["results"]! as! NSArray) as Array)
                    if !res.isEmpty {
                        let userFromDB = self.saveUser(result: res[0])
                        completionHandler(nil, userFromDB)
                    } else {
                        completionHandler(nil, nil)
                    }
                    
                    //completionHandler(nil, !(res as Array).isEmpty)
                    
                }
                
            } catch {
                print(error)
                completionHandler(error as NSError, nil)
            }
            
        }
        task.resume()
    }
    
    func saveUser(result: AnyObject) -> User {
        let user = User(entity: desc!, insertInto: context)
        
        if let uuid = result["uuid"]! {
            user.uuid = uuid as? String
        }
        
        if let firstname = result["firstname"]! {
            user.firstname = firstname as? String
        }
        
        if let lastname = result["lastname"]! {
            user.lastname = lastname as? String
        }
        
        if let email = result["email"]! {
            user.email = email as? String
        }
        
        if let password = result["password"]! {
            user.password = password as? String
        }
        
        ad.saveContext()
        return user
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if emailField.text != "" {
            enableLoginBtn()
        }
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
