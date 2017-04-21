//
//  ChooseImageVC.swift
//  natalie-app-2
//
//  Created by Kuzivakwashe Mutonga on 2017-04-13.
//  Copyright © 2017 Munene Kaumbutho - Evan Zhang. All rights reserved.
//

import UIKit

class ChooseImageVC: UIViewController {

    
    
    @IBOutlet weak var scrollView: UIScrollView!
    var images = [UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var contentWidth: CGFloat = 0.0
        
        let scrollWidth = scrollView.frame.size.width
        for x in 0...4 {
            
            let image = UIImage(named: "img\(x)")
            
            let imageView = UIImageView(image: image)
            images.append(imageView)
            
            var newX: CGFloat = 0.0
            newX = scrollWidth / 2 + scrollWidth * CGFloat(x)
            
            contentWidth += newX
            
            imageView.frame = CGRect(x: newX - 75, y: (scrollView.frame.size.height / 2) - 145, width: 300, height: 200)
            
            // give every image a UITapGestureRecognizer - allow a function to be called everytime as image is tapped.
            let imageTapRecognizer = UITapGestureRecognizer(target: self, action:#selector( imageViewTapped(_:)))
            imageTapRecognizer.delegate = self as? UIGestureRecognizerDelegate
            imageTapRecognizer.numberOfTapsRequired = 1
            imageTapRecognizer.isEnabled = true
            imageTapRecognizer.cancelsTouchesInView = false
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(imageTapRecognizer)
            
            scrollView.addSubview(imageView)
            //print("content Width 1: \(contentWidth)")
        }
        
        //print("content Width 2: \(contentWidth)")
        
        scrollView.backgroundColor = UIColor.black
        //scrollView.clipsToBounds = false
        
        scrollView.contentSize = CGSize(width: (contentWidth - 2500.0), height: 350)
    }
    
    func imageViewTapped(_ sender: UITapGestureRecognizer){
        //let tap_location = sender.location(in: scrollView)
        sender.view?.layer.borderColor = UIColor.blue.cgColor
        sender.view?.layer.borderWidth = 4
        print("image has been tapped at \(sender.location(in: scrollView))")
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
