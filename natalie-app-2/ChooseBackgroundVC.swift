//
//  ChooseBackgroundVC.swift
//  natalie-app-2
//
//  Created by Munene Kaumbutho on 2017-05-18.
//  Copyright © 2017 Munene Kaumbutho - Evan Zhang. All rights reserved.
//

import UIKit
import AWSS3
import CoreData

class ChooseBackgroundVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var _user:User!
    private var _portfolioItem: PortfolioItem!
    
    var selectedUser: User {
        get {
            return _user
        } set {
            _user = newValue
        }
    }
    
    var selectedPortfolioItem: PortfolioItem {
        get {
            return _portfolioItem
        } set {
            _portfolioItem = newValue
        }
    }
    
    @IBOutlet weak var backgroundCollectionView: UICollectionView!
    
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var newPortfolioItem: PortfolioItem!
    
    var selectedBackground: BackgroundImage!
    
    var selectedImage = Image(context: context)
    
    var backgrounds = [BackgroundImage]()
    var backgroundList = [BackgroundImage]()
    
    var transferManager = AWSS3TransferManager.default()
    
    
    let b1 = BackgroundImage(name: "Sundays at dawn", filename: "ocean0.jpg", imageURL: "")
    let b2 = BackgroundImage(name: "Sundays at dawn", filename: "ocean1.jpg", imageURL: "")
    let b3 = BackgroundImage(name: "Sundays at dawn", filename: "ocean2.jpeg", imageURL: "")
    let b4 = BackgroundImage(name: "Sundays at dawn", filename: "ocean3.jpeg", imageURL: "")
    let b5 = BackgroundImage(name: "Sundays at dawn", filename: "ocean4.jpeg", imageURL: "")
    let b6 = BackgroundImage(name: "Sundays at dawn", filename: "ocean5.jpeg", imageURL: "")
    let b7 = BackgroundImage(name: "Sundays at dawn", filename: "ocean6.jpeg", imageURL: "")
    let b8 = BackgroundImage(name: "Sundays at dawn", filename: "ocean7.jpeg", imageURL: "")
    let b9 = BackgroundImage(name: "Sundays at dawn", filename: "ocean8.jpeg", imageURL: "")
    let b10 = BackgroundImage(name: "Sundays at dawn", filename: "ocean9.jpeg", imageURL: "")
    let b11 = BackgroundImage(name: "Sundays at dawn", filename: "ocean10.jpeg", imageURL: "")
    let b12 = BackgroundImage(name: "Sundays at dawn", filename: "ocean11.jpeg", imageURL: "")
    let b13 = BackgroundImage(name: "Sundays at dawn", filename: "ocean12.jpg", imageURL: "")
    let b14 = BackgroundImage(name: "Sundays at dawn", filename: "ocean13.jpg", imageURL: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        editButton.isEnabled = false
        
        backgrounds.append(b1)
        backgrounds.append(b2)
        backgrounds.append(b3)
        backgrounds.append(b4)
        backgrounds.append(b5)
        backgrounds.append(b6)
        backgrounds.append(b7)
        backgrounds.append(b8)
        backgrounds.append(b9)
        backgrounds.append(b10)
        backgrounds.append(b11)
        backgrounds.append(b12)
        backgrounds.append(b13)
        backgrounds.append(b14)

        // Do any additional setup after loading the view.
        backgroundCollectionView.delegate = self
        backgroundCollectionView.dataSource = self
        
        getBackgroundImageUrls {data in
            self.backgroundCollectionView.reloadData()
        }
        
        //let attributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 9)]
        //navigationBar.topItem?.backBarButtonItem?.setTitleTextAttributes(attributes, for: UIControlState.normal)
        
    }
    
    func backButtonPressed() {
        
    }
    
    func getBackgroundImageUrls(completionHandler: @escaping () -> ()){
        
        for background in backgrounds {
            
            let downloadFileUrl = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(background.filename)")
            let downloadRequest = AWSS3TransferManagerDownloadRequest()
            downloadRequest?.bucket = "natalie-app"
            downloadRequest?.key = "\(background.filename)"
            downloadRequest?.downloadingFileURL = downloadFileUrl
            
            transferManager.download(downloadRequest!).continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask<AnyObject>) -> Any? in
                if let error = task.error as NSError? {
                    if error.domain == AWSS3TransferManagerErrorDomain, let code = AWSS3TransferManagerErrorType(rawValue: error.code){
                        switch(code) {
                            case .cancelled, .paused:
                                break
                            default:
                                print("Error downloading: \(String(describing: downloadRequest?.key)) Error: \(error)")
                        }
                    } else {
                        print("Error downloading: \(String(describing: downloadRequest?.key)) Error: \(error)")
                    }
                    return nil
                }
                
                print("Download complete for: \(String(describing: downloadRequest?.key))")
                background.imageURL = downloadFileUrl.path
                self.backgroundList.append(background)
                
                completionHandler()
                return nil
            })
        }
        
        
       
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BackgroundImageCell", for: indexPath) as? BackgroundImageCell {
            
            let background = backgroundList[indexPath.row]
            cell.configureCell(background)
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cells = collectionView.visibleCells as! [BackgroundImageCell]
        selectedBackground = nil
        
        for cell in cells {
            let cellImageView = cell.backgroundImageView
            let cellLabel = cell.backgroundImageLabel
            
            cellImageView?.layer.borderColor = nil
            cellImageView?.layer.borderWidth = 0
            
            cellLabel?.textColor = UIColor.black
            cellLabel?.shadowColor = nil
            cellLabel?.shadowOffset = CGSize(width: 0.0, height: 0.0)
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! BackgroundImageCell
        
        let cellImageView = cell.backgroundImageView
        let cellLabel = cell.backgroundImageLabel
    
        cellImageView?.layer.borderColor = UIColor.blue.cgColor
        cellImageView?.layer.borderWidth = 3
        
        cellLabel?.shadowColor = UIColor.black
        cellLabel?.shadowOffset = CGSize(width: 0.5, height: 0.0)
        cellLabel?.textColor = UIColor.blue
        
        
        editButton.isEnabled = true
        selectedBackground = backgroundList[indexPath.row]
    }
    
    @IBAction func editBtnPressed(_ sender: Any) {
        
        selectedPortfolioItem.image = selectedImage
        ad.saveContext()
        
        let editPortfolioItemVC = self.storyboard?.instantiateViewController(withIdentifier: "EditPortfolioItemVC") as! EditPortfolioItemVC
        editPortfolioItemVC.selectedPortfolioItem = selectedPortfolioItem
        editPortfolioItemVC.selectedUser = selectedUser
        editPortfolioItemVC.selectedBackground = selectedBackground!
        self.present(editPortfolioItemVC, animated: true, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! BackgroundImageCell
        let cellImage = cell.backgroundImageView.image
        let img = UIImageJPEGRepresentation(cellImage!, 1)
        let thumbnail = UIImageJPEGRepresentation(cellImage!, 0.1)
        
        selectedImage.img = img! as NSData
        selectedImage.thumbnail = thumbnail! as NSData
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return backgroundList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 110)
    }
    

}
