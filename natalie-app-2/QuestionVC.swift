//
//  QuestionVC.swift
//  natalie-app-2
//
//  Created by Munene Kaumbutho on 2017-05-16.
//  Copyright © 2017 Munene Kaumbutho - Evan Zhang. All rights reserved.
//

import Foundation
import UIKit

class QuestionVC: UIViewController {
    
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
    @IBOutlet weak var questionTextView: UITextField!
    @IBOutlet weak var buttonStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view:
        questionLabel.alpha = 0.0
        questionTextView.alpha = 0.0
        buttonStackView.alpha = 0.0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        greetingLabel.text = "Hi, \(selectedUser.firstname!).."
        self.greetingLabel.fadeOut(1.0, delay: 1.0, completion: {(finished: Bool) -> Void in
            self.questionLabel.fadeIn(1.0, delay: 0.5)
            self.questionTextView.fadeIn(1.0, delay: 0.5)
        })
        
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
