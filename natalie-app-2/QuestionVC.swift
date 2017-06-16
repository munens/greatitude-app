//
//  QuestionVC.swift
//  natalie-app-2
//
//  Created by Munene Kaumbutho on 2017-05-16.
//  Copyright © 2017 Munene Kaumbutho - Evan Zhang. All rights reserved.
//

import Foundation
import UIKit

class QuestionVC: UIViewController, UITextViewDelegate {
    
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
    @IBOutlet weak var nxtBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view:
        //print(selectedUser!)
        
        selectPicBtn.layer.borderWidth = 1.0
        selectPicBtn.layer.borderColor = UIColor.white.cgColor
        selectPicBtn.layer.cornerRadius = 3
        
        nxtBtn.layer.borderWidth = 1.0
        nxtBtn.layer.borderColor = UIColor.white.cgColor
        nxtBtn.layer.cornerRadius = 3
        
        questionLabel.alpha = 0.0
        
        questionTextView.delegate = self
        questionTextView.alpha = 0.0
        questionTextView.text = "I am thankful for.."
        questionTextView.textColor = .lightGray
        questionTextView.layer.cornerRadius = 3
        
        buttonStackView.alpha = 0.0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //print(selectedUser!)
        greetingLabel.text = "Hi, \(selectedUser.firstname!).."
        
        self.greetingLabel.fadeOut(1.0, delay: 1.0, completion: {(finished: Bool) -> Void in
            self.questionLabel.fadeIn(1.0, delay: 0.5)
            self.questionTextView.fadeIn(1.0, delay: 0.5)
        })
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if questionTextView.text == "I am thankful for.." {
            questionTextView.text = ""
            questionTextView.textColor = .black
        }
        buttonStackView.fadeIn(1.0, delay: 0.5)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if questionTextView.text == "" {
            questionTextView.text = "I am thankful for.."
            questionTextView.textColor = .lightGray
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func selectPicBtnPressed(_ sender: Any) {
    }
    
    @IBAction func nextBtnPressed(_ sender: Any) {
        if (questionTextView.text != nil && questionTextView.text != "") {
            
            let portfolioItem = PortfolioItem(context: context)
            
            if let quote = questionTextView.text {
                portfolioItem.quote = quote
            }
            
            portfolioItem.user = selectedUser
            
            ad.saveContext()
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
