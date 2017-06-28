//
//  ChooseImageVC.swift
//  natalie-app-2
//
//  Created by Kuzivakwashe Mutonga on 2017-04-13.
//  Copyright © 2017 Munene Kaumbutho - Evan Zhang. All rights reserved.
//

import UIKit
import AWSS3

class ChooseImageVC: UIViewController {

    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    let transferManager = AWSS3TransferManager.default()
    
    @IBOutlet weak var scrollView: UIScrollView!
    var images = [UIImageView]()
    
    var themeTasks = [AWSTask<AnyObject>]()
    var imageList = [AnyObject]()
    var imageURLList = [URL]()
    var themes = ["Ocean theme", "Medieval theme", "Black Pattern theme", "Rainbow Background theme", "Blue and Pink theme"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        editButton.isEnabled = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var contentWidth: CGFloat = 0.0
        
        print("getting image list: \(imageList)" )
        
        let scrollWidth = scrollView.frame.size.width
        
        getImageTasks {urls in
            
            for (index, url) in urls.enumerated() {
                
                let image = UIImage(contentsOfFile: url.path)
                let label = UILabel(frame: CGRect(x:0, y:240, width: 345, height: 30))
                label.text = self.themes[index]
                label.textAlignment = NSTextAlignment.center
                
                let imageView = UIImageView(image: image)
                
                imageView.layer.shadowColor = UIColor.black.cgColor
                imageView.layer.shadowOpacity = 1
                imageView.layer.shadowOffset = CGSize.zero
                imageView.layer.shadowRadius = 10
                //imageView.layer.shadowPath = UIBezierPath(rect: imageView.bounds).cgPath
                //imageView.layer.shouldRasterize = true
                
                imageView.addSubview(label)
                
                self.images.append(imageView)
                
                var newX: CGFloat = 0.0
                newX = scrollWidth / 2 + scrollWidth * CGFloat(index)
                
                contentWidth += newX
                
                imageView.frame = CGRect(x: newX - 75, y: (self.scrollView.frame.size.height / 2) - 145, width: 345, height: 230)
                
                // give every image a UITapGestureRecognizer - allow a function to be called everytime as image is tapped.
                let imageTapRecognizer = UITapGestureRecognizer(target: self, action:#selector( self.imageViewTapped(_:)))
                imageTapRecognizer.delegate = self as? UIGestureRecognizerDelegate
                imageTapRecognizer.numberOfTapsRequired = 1
                imageTapRecognizer.isEnabled = true
                imageTapRecognizer.cancelsTouchesInView = false
                imageView.isUserInteractionEnabled = true
                imageView.addGestureRecognizer(imageTapRecognizer)
                
                self.scrollView.addSubview(imageView)
                //print("content Width 1: \(contentWidth)")
            }
            
            self.scrollView.contentSize = CGSize(width: (contentWidth - 2500.0), height: 350)
        }
        
        
        //print("content Width 2: \(contentWidth)")
        
        //scrollView.backgroundColor = UIColor.black
        //scrollView.clipsToBounds = false
        
        
    }
    
    func getImageTasks(completionHandler: @escaping ([URL]) -> ()){
    
        for x in 0...4 {
            let downloadFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("img\(x).jpg")
            let downloadRequest = AWSS3TransferManagerDownloadRequest()
            downloadRequest?.bucket = "natalie-app"
            downloadRequest?.key = "img\(x).jpg"
            downloadRequest?.downloadingFileURL = downloadFileURL
            
            transferManager.download(downloadRequest!).continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask<AnyObject>) -> Any? in
                if let error = task.error as NSError? {
                    if error.domain == AWSS3TransferManagerErrorDomain, let code = AWSS3TransferManagerErrorType(rawValue: error.code) {
                        
                        switch(code){
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
                self.imageURLList.append(downloadFileURL)
                //let downloadOutput = task.result
                if(self.imageURLList.count == 5){
                    completionHandler(self.imageURLList)
                }
                
                return nil
            })
        }
    }
    
    
    
    func imageViewTapped(_ sender: UITapGestureRecognizer){
        //let tap_location = sender.location(in: scrollView)
        for image in images {
            image.layer.borderWidth = 0
            let image_label = image.subviews.first as! UILabel
            image_label.shadowColor = nil
            image_label.textColor = UIColor.black
            image_label.shadowOffset = CGSize(width: 0, height: 0)
        }
        let chosen_image = sender.view
        chosen_image?.layer.borderColor = UIColor.blue.cgColor
        chosen_image?.layer.borderWidth = 6
        let image_label = chosen_image?.subviews.first as! UILabel
        image_label.textColor = UIColor.blue
        image_label.shadowColor = UIColor.black
        image_label.shadowOffset = CGSize(width: 0.5, height: 0.0)
        editButton.isEnabled = true
    }
    
    
    /*
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        getTouchLocation(touches: touches as NSSet)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        getTouchLocation(touches: touches as NSSet)
    }
    
    func getTouchLocation(touches: NSSet){
        let touch = touches.allObjects[0]
        
        
    }*/
    
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

}
