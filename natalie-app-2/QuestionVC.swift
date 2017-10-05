//
//  QuestionVC.swift
//  natalie-app-2
//
//  Created by Munene Kaumbutho on 2017-05-16.
//  Copyright © 2017 Munene Kaumbutho - Evan Zhang. All rights reserved.
//

import Foundation
import UIKit
import DropDown
import FBSDKLoginKit

class QuestionVC: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var _user:User!
    
    var selectedUser: User {
        get {
            return _user
        } set {
            _user = newValue
        }
    }
    
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var selectPicBtn: UIButton!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var viewPortfolioBtn: UIButton!
    @IBOutlet weak var nxtBtn: UIButton!
    
    let dropDown = DropDown()
    
    var imagePickerController: UIImagePickerController!
    
    var portfolioItem = PortfolioItem(context: context)
    var selectedImage = Image(context: context)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view:
        //print(selectedUser!)
        
        imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        
        selectPicBtn.layer.borderWidth = 1.0
        selectPicBtn.layer.borderColor = UIColor.white.cgColor
        selectPicBtn.layer.cornerRadius = 3
        
        nxtBtn.layer.borderWidth = 1.0
        nxtBtn.layer.borderColor = UIColor.white.cgColor
        nxtBtn.layer.cornerRadius = 3
        
        viewPortfolioBtn.layer.borderWidth = 1.0
        viewPortfolioBtn.layer.borderColor = UIColor.white.cgColor
        viewPortfolioBtn.layer.cornerRadius = 3
        
        questionLabel.alpha = 0.0
        
        questionTextView.delegate = self
        questionTextView.alpha = 0.0
        questionTextView.text = "I am grateful for.."
        questionTextView.textColor = .lightGray
        questionTextView.layer.cornerRadius = 3
        
        buttonStackView.alpha = 0.0
 
        //menuBtn.isEnabled = selectedUser.email != nil
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if (selectedUser.firstname) != nil {
            greetingLabel.text = "Hi, \(selectedUser.firstname!).."
        } else {
            greetingLabel.text = "Hi, guest"
        }
        
        self.greetingLabel.fadeOut(1.0, delay: 1.0, completion: {(finished: Bool) -> Void in
            self.questionLabel.fadeIn(1.0, delay: 0.5)
            self.questionTextView.fadeIn(1.0, delay: 0.5)
        })
        
    }
    
    func openWelcomeVC() {
        let welcomeVC = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
        present(welcomeVC, animated: true, completion: nil)
    }
    
    @IBAction func menuBtnClicked(_ sender: Any) {
        
        dropDown.dataSource = ["logout"]
        
        //let logoutBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        //logoutBtn.setTitle("logout", for: .normal)
        //logoutBtn.setTitleColor(UIColor.white, for: .normal)
        //let logoutBtnView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        //logoutBtnView.addSubview(logoutBtn)
        
        dropDown.anchorView = menuBtn
        
        DropDown.appearance().textColor = UIColor.white
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 15)
        DropDown.appearance().backgroundColor = UIColor.black
        DropDown.appearance().selectionBackgroundColor = UIColor.lightGray
        DropDown.appearance().cellHeight = 40
        
        let dropDownOffset = (dropDown.anchorView?.plainView.bounds.height)! - 45
        dropDown.bottomOffset = CGPoint(x: 0, y: dropDownOffset)
        dropDown.width = CGFloat(60)
        dropDown.direction = .top
        
        dropDown.show()
        
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            let hasLoginKey = UserDefaults.standard.bool(forKey: "hasLoginKey")
            if(FBSDKAccessToken.current() != nil) {
                let loginManager = FBSDKLoginManager()
                loginManager.logOut()
                self.openWelcomeVC()
            } else if hasLoginKey == true {
                UserDefaults.standard.removeObject(forKey: "email")
                self.openWelcomeVC()
            }
        }
 
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if questionTextView.text == "I am grateful for.." {
            questionTextView.text = ""
            questionTextView.textColor = .black
        }
        buttonStackView.fadeIn(1.0, delay: 0.5)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if questionTextView.text == "" {
            questionTextView.text = "I am grateful for.."
            questionTextView.textColor = .lightGray
        }
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage /* Using s3 -> URL */ {
        let size = image.size
        
        let widthRatio = targetSize.width / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // find image oriantation and form rectangle from it:
        var newSize: CGSize
        if(widthRatio > heightRatio){
            newSize = CGSize(width: size.width*heightRatio, height: size.height*heightRatio)
        } else {
            newSize = CGSize(width: size.width*widthRatio, height: size.height*widthRatio)
        }
        // create a new rect from the result:
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        portfolioItem.created_at = NSDate()
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            
            var cellImage = UIImage()
            var cellThumbnail = UIImage()
            
            if UIDevice.current.userInterfaceIdiom == .phone {
                cellImage = resizeImage(image: image, targetSize: CGSize(width: 1000.0, height: 1000.0))
                cellThumbnail = resizeImage(image: image, targetSize: CGSize(width: 50.0, height: 50.0))
            } else {
                cellImage = resizeImage(image: image, targetSize: CGSize(width: 2000.0, height: 2000.0))
                cellThumbnail = resizeImage(image: image, targetSize: CGSize(width: 100.0, height: 100.0))
            }
            
            let img = UIImageJPEGRepresentation(cellImage, 1.0)
            let thumbnail = UIImageJPEGRepresentation(cellThumbnail, 0.0)
            
            selectedImage.img = img! as NSData
            selectedImage.thumbnail = thumbnail! as NSData
            
            if let quote = questionTextView.text {
                portfolioItem.quote = quote
            }
            
            portfolioItem.user = selectedUser
            portfolioItem.image = selectedImage
            
            ad.saveContext()
            imagePickerController.dismiss(animated: true, completion: nil)
            
        } else if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            var cellImage = UIImage()
            var cellThumbnail = UIImage()
            
            if UIDevice.current.userInterfaceIdiom == .phone {
                cellImage = resizeImage(image: image, targetSize: CGSize(width: 1000.0, height: 1000.0))
                cellThumbnail = resizeImage(image: image, targetSize: CGSize(width: 50.0, height: 50.0))
            } else {
                cellImage = resizeImage(image: image, targetSize: CGSize(width: 2000.0, height: 2000.0))
                cellThumbnail = resizeImage(image: image, targetSize: CGSize(width: 100.0, height: 100.0))
            }
            
            let img = UIImageJPEGRepresentation(cellImage, 1.0)
            let thumbnail = UIImageJPEGRepresentation(cellThumbnail, 0.0)
            
            selectedImage.img = img! as NSData
            selectedImage.thumbnail = thumbnail! as NSData
            selectedImage.name = ""
            
            if let quote = questionTextView.text {
                portfolioItem.quote = quote
            }
            
            portfolioItem.user = selectedUser
            portfolioItem.image = selectedImage
            
            ad.saveContext()
            imagePickerController.dismiss(animated: true, completion: nil)
        }
        
        imagePickerController.dismiss(animated: true, completion: nil)
        
        let editPortfolioEditVC = self.storyboard?.instantiateViewController(withIdentifier: "EditPortfolioItemVC") as! EditPortfolioItemVC
        editPortfolioEditVC.selectedUser = selectedUser
        editPortfolioEditVC.selectedPortfolioItem = portfolioItem
        self.present(editPortfolioEditVC, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func viewPortfolioBtnPressed(_ sender: Any) {
        let mainVC = storyboard?.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        mainVC.selectedUser = selectedUser
        present(mainVC, animated: true, completion: nil)
        
    }

    @IBAction func selectPicBtnPressed(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Select a photo", message: "Would you like to use the camera or choose and image from your gallery?", preferredStyle: UIAlertControllerStyle.alert)
        
        
        alertController.addAction(UIAlertAction(title: "Use camera", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                self.imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
                self.imagePickerController.allowsEditing = false
                self.present(self.imagePickerController, animated: true, completion: nil)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Use gallery", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction) in
            self.present(self.imagePickerController, animated: true, completion: nil)
        }))
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func nextBtnPressed(_ sender: Any) {
        if (questionTextView.text != nil && questionTextView.text != "") {
            
            portfolioItem.created_at = NSDate()
            
            if let quote = questionTextView.text {
                portfolioItem.quote = quote
            }
            
            portfolioItem.user = selectedUser
            
            ad.saveContext()
            
            let chooseImageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChooseImageVC") as! ChooseImageVC
            chooseImageVC.selectedUser = selectedUser
            chooseImageVC.selectedPortfolioItem = portfolioItem
            self.present(chooseImageVC, animated: true, completion: nil)
        }
    }
}

extension UIView {
    func fadeIn(_ duration: TimeInterval, delay: TimeInterval, completion: @escaping((Bool) -> Void) = {(finished: Bool) -> Void in} ) {
        UIView.animate(withDuration: duration, delay: delay, options: [.curveEaseIn], animations: {
            self.alpha = 1.0
        }, completion: completion)
    }
    
    func fadeOut(_ duration: TimeInterval, delay: TimeInterval, completion: @escaping((Bool) -> Void) = {(finished: Bool) -> Void in} ) {
        UIView.animate(withDuration: duration, delay: delay, options: [.curveEaseIn], animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
}


