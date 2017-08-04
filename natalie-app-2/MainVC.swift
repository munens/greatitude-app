//
//  MainVC.swift
//  natalie-app-2
//
//  Created by Kuzivakwashe Mutonga on 2017-04-12.
//  Copyright © 2017 Munene Kaumbutho - Evan Zhang. All rights reserved.
//

import UIKit
import CoreData
import LocalAuthentication
import FBSDKShareKit
import FacebookShare

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var _user:User!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noItemsStackView: UIStackView!
    @IBOutlet weak var optionsView: UIView!
    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!

    
    var portfolioItems: [PortfolioItem] = []
    
    var selectedUser: User {
        get {
            return _user
        } set {
            _user = newValue
        }
    }
    
    var selectedPortfolioItem: PortfolioItem!
    
    let cellSpacing: CGFloat = 12
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        
        editBtn.layer.borderWidth = 1
        editBtn.layer.borderColor = UIColor.init(red: 0.0, green: 122/255, blue: 255/255, alpha: 1.0).cgColor
        editBtn.layer.cornerRadius = 3
        
        noItemsStackView.isHidden = true
        optionsView.isHidden = true
        
        portfolioItems = selectedUser.portfolioItem!.sortedArray(using: [NSSortDescriptor(key: "created_at", ascending: true)]) as! [PortfolioItem]
        
        if portfolioItems.count == 0 {
            tableView.isHidden = true
            noItemsStackView.isHidden = false
        }
        
        backgroundView.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainVC.backgroundTapped))
        backgroundView.addGestureRecognizer(tapRecognizer)
        
    }
    
    func backgroundTapped() {
        let portfolioItemCells = tableView.visibleCells
        
        for cell in portfolioItemCells {
            cell.layer.borderWidth = 0
            cell.layer.borderColor = nil
        }
        
        UIView.transition(with: optionsView, duration: 0.5, options: UIViewAnimationOptions.transitionCrossDissolve, animations: { _ in
            self.optionsView.isHidden = true
        }, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        let questionVC = storyboard?.instantiateViewController(withIdentifier: "QuestionVC") as! QuestionVC
        questionVC.selectedUser = selectedUser
        present(questionVC, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return portfolioItems.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        displayOptionsView()
    }
    
    func displayOptionsView(){
        UIView.transition(with: optionsView, duration: 0.5, options: UIViewAnimationOptions.transitionCrossDissolve, animations: { _ in
            self.optionsView.isHidden = false
        }, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        
        let portfolioItemCell = tableView.cellForRow(at: indexPath) as! PortfolioItemCell
        
        let portfolioItemCells = tableView.visibleCells
        
        for cell in portfolioItemCells {
            cell.layer.borderWidth = 0
            cell.layer.borderColor = nil
        }
        
        portfolioItemCell.layer.borderWidth = 4
        portfolioItemCell.layer.borderColor = UIColor.blue.cgColor
        selectedPortfolioItem = portfolioItemCell.currentPortfolioItem
     
    }
    /*
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
      /* TODO deselect all rows that arent chosen */
        
    }*/
    
    override func viewWillAppear(_ animated: Bool) {
        /*if let index = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: index, animated: true)
            //imageQuoteCell = index as? ImageQuoteCell
        
            
        }*/
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a dequeue reuseable cell here to return.
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PortfolioItemCell", for: indexPath) as? PortfolioItemCell {
            cell.configureCell(portfolioItem: portfolioItems[indexPath.section])
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    
    @IBAction func editBtnPressed(_ sender: UIButton) {
        let editPortfolioItemVC = storyboard?.instantiateViewController(withIdentifier: "EditPortfolioItemVC") as! EditPortfolioItemVC
        editPortfolioItemVC.selectedUser = selectedUser
        editPortfolioItemVC.selectedPortfolioItem = selectedPortfolioItem
       
        present(editPortfolioItemVC, animated: true, completion: nil)
    }
    
    @IBAction func shareBtnPressed(_ sender: UIButton) {
        if let image = selectedPortfolioItem.image?.final {
            let photo: FBSDKSharePhoto = FBSDKSharePhoto()
            let content: FBSDKSharePhotoContent = FBSDKSharePhotoContent()
            photo.image = UIImage(data: image as Data)
            photo.isUserGenerated = true
            content.photos = [photo]
    
            //content.contentURL = NSURL(string: "http://developers.facebook.com")! as URL
            FBSDKShareDialog.show(from: self, with: content, delegate: nil)
            
        }
    }
    
    
    @IBAction func deleteBtnPressed(_ sender: Any) {
    }
    

}
