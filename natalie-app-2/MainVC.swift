//
//  MainVC.swift
//  natalie-app-2
//
//  Created by Kuzivakwashe Mutonga on 2017-04-12.
//  Copyright © 2017 Munene Kaumbutho - Evan Zhang. All rights reserved.
//

import UIKit

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var _user:User!
    @IBOutlet weak var tableView: UITableView!
    
    
    var selectedUser: User {
        get {
            return _user
        } set {
            _user = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self

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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let tableViewCell = tableView.cellForRow(at: indexPath)
        tableViewCell?.layer.borderWidth = 4
        tableViewCell?.layer.borderColor = UIColor.blue.cgColor
        
        let cell = tableViewCell as! ImageQuoteCell
        cell.quoteImageOverlay.isHidden = false
    }
    /*
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
      /* TODO deselect all rows that arent chosen */
        
    }*/
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: index, animated: true)
            //imageQuoteCell = index as? ImageQuoteCell
        
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a dequeue reuseable cell here to return.
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ImageQuoteCell", for: indexPath) as? ImageQuoteCell {
            cell.configureCell()
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    @IBAction func viewBtnPressed(_ sender: UIButton) {
        
    }
    @IBAction func editBtnPressed(_ sender: UIButton) {
        
    }
    @IBAction func shareBtnPressed(_ sender: UIButton) {
        
    }

}
