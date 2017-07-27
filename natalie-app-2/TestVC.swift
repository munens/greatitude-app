//
//  testVC.swift
//  natalie-app-2
//
//  Created by Munene Kaumbutho on 2017-07-18.
//  Copyright © 2017 Munene Kaumbutho - Evan Zhang. All rights reserved.
//

import UIKit

class TestVC: UIViewController {
    
    private var _selectedImage: UIImage!
    @IBOutlet weak var newImage: UIImageView!
    
    var selectedImage: UIImage {
        get {
            return _selectedImage
        } set {
            _selectedImage = newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        newImage.image = selectedImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
