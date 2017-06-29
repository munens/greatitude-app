//
//  EditPortfolioItemVC.swift
//  natalie-app-2
//
//  Created by Munene Kaumbutho on 2017-05-24.
//  Copyright © 2017 Munene Kaumbutho - Evan Zhang. All rights reserved.
//

import UIKit

class EditPortfolioItemVC: UIViewController {
    
    private var _selectedBackground: BackgroundImage!
    private var _portfolioItem: PortfolioItem!
    
    var selectedBackground: BackgroundImage {
        get {
            return _selectedBackground
        } set {
           _selectedBackground = newValue
        }
    }
    
    var selectedPortfolioItem: PortfolioItem {
        get {
            return _portfolioItem
        } set {
            _portfolioItem = newValue
        }
    }
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var backgroundImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "edit \(selectedBackground.name)"
        backgroundImage.image = UIImage(contentsOfFile: selectedBackground.imageURL)
        
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
    
    func getPortfolioItems() {
        
    }

}
