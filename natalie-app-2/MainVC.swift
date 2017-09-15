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

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, FBSDKSharingDelegate, NSFetchedResultsControllerDelegate {
    
    private var _user:User!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noItemsStackView: UIStackView!
    @IBOutlet weak var optionsView: UIView!
    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var portfolioItemActionStackView: UIStackView!
    
    var facebookBtn = FBSDKShareButton()
    
    var controller: NSFetchedResultsController<PortfolioItem>!
    
    var portfolioItems: [PortfolioItem] = []
    
    var selectedUser: User {
        get {
            return _user
        } set {
            _user = newValue
        }
    }
    
    var API_URL = "https://infinite-wildwood-35465.herokuapp.com"
    //var API_URL = "http://localhost:5000"
    
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
        
        shareBtn.layer.borderWidth = 1
        shareBtn.layer.borderColor = UIColor.init(red: 0.0, green: 122/255, blue: 255/255, alpha: 1.0).cgColor
        shareBtn.layer.cornerRadius = 3
        
        deleteBtn.layer.borderWidth = 1
        deleteBtn.layer.borderColor = UIColor.init(red: 0.0, green: 122/255, blue: 255/255, alpha: 1.0).cgColor
        deleteBtn.layer.cornerRadius = 3
        
        
        let edit = portfolioItemActionStackView.subviews[0]
        facebookBtn.center = edit.center
        facebookBtn.layer.frame = edit.frame
        //portfolioItemActionStackView.removeArrangedSubview(edit)
        //portfolioItemActionStackView.addArrangedSubview(facebookBtn)
        
        noItemsStackView.isHidden = true
        optionsView.isHidden = true
        
        attemptFetch()
        
        backgroundView.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainVC.backgroundTapped))
        backgroundView.addGestureRecognizer(tapRecognizer)
        
    }
    
    func attemptFetch() {
        let fetchRequest: NSFetchRequest<PortfolioItem> = PortfolioItem.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created_at", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        fetchRequest.predicate = NSPredicate(format: "user == %@", selectedUser)
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        self.controller = controller
        
        do {
            try controller.performFetch()
            
        } catch {
            let error = error as NSError
            print("\(error)")
        }
        
        if (controller.fetchedObjects?.count)! > 0 {
            portfolioItems = controller.fetchedObjects!
            
            for item in portfolioItems {
                if item.user != selectedUser {
                    print("no: , \(item)")
                }
            }
        }
    
        
        if portfolioItems.count == 0 {
            tableView.isHidden = true
            noItemsStackView.isHidden = false
        }
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

        if let sections = controller.sections {
            return sections.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {
            let sec = sections[section]
            return sec.numberOfObjects
        }
        
        return 0
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
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch(type) {
            case.insert:
                if let indexPath = newIndexPath {
                    tableView.insertRows(at: [indexPath], with: .fade)
                }
                break
            
            case.delete:
                if let indexPath = indexPath {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
                break
            
            case.update:
                if let indexPath = indexPath {
                    let cell = tableView.cellForRow(at: indexPath) as! PortfolioItemCell
                    let portfolioItem = controller.object(at: indexPath) as! PortfolioItem
                    cell.configureCell(portfolioItem: portfolioItem)
                }
                break
            case.move:
                if let indexPath = indexPath {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
                if let indexPath = newIndexPath {
                    tableView.insertRows(at: [indexPath], with: .fade)
                }
                break
        }
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
            cell.configureCell(portfolioItem: portfolioItems[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
    
    func saveSharePostInfo() {
        let url: NSURL = NSURL(string: API_URL + "/api/posts")!
        var request = URLRequest(url: url as URL)
        
        request.httpMethod = "POST"
        
        let postParams = "uuid="+selectedUser.uuid!
        request.httpBody = postParams.data(using: String.Encoding.utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
        
            if error != nil {
                print(error!)
                return;
            }
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let json = jsonResponse {
                    print(json)
                }
                
            } catch {
                print(error)
            }
            
        })
        task.resume()
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
            photo.image = UIImage(data: image as Data)
            photo.caption = selectedPortfolioItem.quote
            photo.isUserGenerated = true
            let content: FBSDKSharePhotoContent = FBSDKSharePhotoContent()
            content.photos = [photo]
            
            let shareDialog: FBSDKShareDialog = FBSDKShareDialog()
            shareDialog.shareContent = content
            shareDialog.delegate = self
            shareDialog.fromViewController = self
            //shareDialog.mode = .automatic
            shareDialog.mode = .native
            
            print(shareDialog.canShow())
            if !shareDialog.canShow() {
               showAlertController()
            }
            shareDialog.show()
        }
 
    }
    
    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable : Any]!) {
        saveSharePostInfo()
        print(results)
    }
    
    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        print("sharer NSError \(error)")
        //print(error.description)
        showAlertController()
    }
    
    func sharerDidCancel(_ sharer: FBSDKSharing!) {
        print("sharerDidCancel")
    }
    
    func showAlertController(){
        let alertController = UIAlertController(title: "Facebook App not installed", message: "Sharing requires the Facebook app to be installed. Would you like to download it from the App Store?", preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "Open AppStore", style: UIAlertActionStyle.default, handler:{(action: UIAlertAction) in
            self.openFacebookAppStore()
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {(action: UIAlertAction) in
            alertController.dismiss(animated: true, completion: nil)
            
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func openFacebookAppStore() {
        if let url = URL(string: "itms-apps://itunes.apple.com/us/developer/facebook-inc/id284882218"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func deleteBtnPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "Delete this image:", message: "Are you sure you would like to delete this image from your portfolio?", preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction) in
            context.delete(self.selectedPortfolioItem)
            ad.saveContext()
            self.attemptFetch()
            
            self.tableView.reloadData()
            self.optionsView.isHidden = true
        }))
        
        alertController.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    

}
