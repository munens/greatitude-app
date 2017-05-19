//
//  ChooseBackgroundVC.swift
//  natalie-app-2
//
//  Created by Munene Kaumbutho on 2017-05-18.
//  Copyright © 2017 Munene Kaumbutho - Evan Zhang. All rights reserved.
//

import UIKit

class ChooseBackgroundVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var backgroundCollectionView: UICollectionView!
    
    var backgroundImages = [BackgroundImage]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        backgroundCollectionView.delegate = self
        backgroundCollectionView.dataSource = self
        
        createImageBackgrounds()
        
    }
    
    func createImageBackgrounds(){
        for x in 0...12 {
            //let image = UIImage(named: "ocean\(x)")
            
            let backgroundImage = BackgroundImage(name: "ocean\(x)")
            backgroundImages.append(backgroundImage)
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
            
            let backgroundImage = backgroundImages[indexPath.row]
            cell.configureCell(backgroundImage)
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return backgroundImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 110)
    }
    

}
