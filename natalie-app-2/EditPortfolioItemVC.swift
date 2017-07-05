//
//  EditPortfolioItemVC.swift
//  natalie-app-2
//
//  Created by Munene Kaumbutho on 2017-05-24.
//  Copyright © 2017 Munene Kaumbutho - Evan Zhang. All rights reserved.
//

import UIKit

class EditPortfolioItemVC: UIViewController, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    private var _selectedBackground: BackgroundImage!
    private var _portfolioItem: PortfolioItem!
    private var _selectedUser: User!
    
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
    
    var selectedUser: User {
        get {
            return _selectedUser
        } set {
            _selectedUser = newValue
        }
    }
    
    let fonts = UIFont.familyNames
    let colors = [ 0x000000, 0xfe0000, 0xff7900, 0xffb900, 0xffde00, 0xfcff00, 0xd2ff00, 0x05c000, 0x00c0a7, 0x0600ff, 0x6700bf, 0x9500c0, 0xbf0199, 0xffffff ]
    
    var quoteText = UITextView()
    var imageQuoteLabel = UILabel()
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var fontSizeStepper: UIStepper!
    @IBOutlet weak var storePicker: UIPickerView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        quoteText.delegate = self
        
        fontSizeStepper.wraps = true
        fontSizeStepper.autorepeat = true
        fontSizeStepper.maximumValue = 36
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
        storePicker.layer.borderWidth = 1
        storePicker.layer.borderColor = UIColor.init(red: 0.0, green: 122/255, blue: 255/255, alpha: 1.0).cgColor
        storePicker.layer.cornerRadius = 4
        //storePicker.layer.backgroundColor = UIColor.init(red: 9.0, green: 22.0, blue: 45.0, alpha: 1).cgColor
        
        self.title = "edit \(selectedBackground.name)"
        backgroundImage.image = UIImage(contentsOfFile: selectedBackground.imageURL)
        
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action:#selector(self.imageViewTapped(_:)))
        imageTapRecognizer.delegate = self as? UIGestureRecognizerDelegate
        imageTapRecognizer.numberOfTapsRequired = 1
        imageTapRecognizer.isEnabled = true
        imageTapRecognizer.cancelsTouchesInView = false
        backgroundImage.isUserInteractionEnabled = true
        backgroundImage.addGestureRecognizer(imageTapRecognizer)
        
        quoteText.frame = CGRect(x: 0, y: backgroundImage.frame.size.height/2, width: backgroundImage.frame.size.width, height: 75)
        quoteText.textAlignment = .center
        //quoteText.lineBreakMode = .byClipping
        //imageQuoteLabel.adjustsFontSizeToFitWidth = true
        quoteText.backgroundColor = UIColor.clear
        quoteText.text = selectedPortfolioItem.quote!
        fontSizeStepper.minimumValue = Double((quoteText.font?.pointSize)!)
        
        adjustTextViewWidth(textView: quoteText)
        
        quoteText.textColor = UIColor.white
        let labelGesture = UIPanGestureRecognizer(target: self, action: #selector(self.userDragText(gesture:)))
        quoteText.addGestureRecognizer(labelGesture)
        quoteText.isUserInteractionEnabled = true
        self.view.addSubview(quoteText)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("textViewDidBeginEditting")
        changeTextViewStyle()
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        print("textViewDidChange")
        saveQuote(text: textView.text)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("textViewDidEndEditing")
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let font = fonts[row]
        return font
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fonts.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString: NSAttributedString
        attributedString = NSAttributedString(string: fonts[row], attributes: [NSForegroundColorAttributeName: UIColor.init(red: 0.0, green: 122/255, blue: 255/255, alpha: 1.0)])
        return attributedString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        changeTextViewStyle()
        quoteText.font = UIFont(name: fonts[row], size: (quoteText.font?.pointSize)!)
    }
    
    func imageViewTapped(_ sender: UITapGestureRecognizer){
        print("imageViewTapped")
        unchangeTextViewStyle()

    }
    
    func adjustTextViewWidth(textView: UITextView) {
        let currentWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: currentWidth, height: backgroundImage.frame.size.height))
        
        let newSize = textView.sizeThatFits(CGSize(width: currentWidth, height: backgroundImage.frame.size.height))
        var newFrame = textView.frame
        
        newFrame.size = CGSize(width: max(newSize.width, currentWidth), height: newSize.height)
        textView.frame = newFrame
    }
    
    func userDragText(gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: self.view)
        let newLoc = CGPoint(x: gesture.view!.center.x, y: gesture.view!.center.y)
        if let gestureView = gesture.view {
            switch gesture.state {
                case .changed:
                    if insideDraggableArea(point: newLoc) {
                        gestureView.center = CGPoint(x: gestureView.center.x + translation.x, y: gestureView.center.y + translation.y)
                        gesture.setTranslation(.zero, in: self.view)
                    } else {
                        gestureView.center = newGestureCoords(point: newLoc)
                    }
                case .ended:
                    saveLabelPostion(point: gestureView.center)
                default:
                    break
            }
        }

    }
    
    func changeTextViewStyle() {
        let range = NSRange(location: 0, length: quoteText.text.characters.count)
        let attributedText = NSMutableAttributedString(string: quoteText.text)
        attributedText.addAttributes([NSBackgroundColorAttributeName: UIColor.black, NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name:(quoteText.font?.familyName)!, size: (quoteText.font?.pointSize)!)!], range: range)
        quoteText.attributedText = attributedText
        quoteText.tintColor = .white
    }
    
    func unchangeTextViewStyle() {
        let range = NSRange(location: 0, length: quoteText.text.characters.count)
        let attributedText = NSMutableAttributedString(string: quoteText.text)
        attributedText.addAttributes([NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name:(quoteText.font?.familyName)!, size: (quoteText.font?.pointSize)!)! ], range: range)
        quoteText.attributedText = attributedText
        quoteText.tintColor = .white
        quoteText.resignFirstResponder()
    }
    
    func insideDraggableArea(point: CGPoint) -> Bool {
        let backgroundImageFrame = self.backgroundImage.frame
        return point.x >= 0 && point.x <= backgroundImageFrame.width
               && point.y >= backgroundImageFrame.minY && point.y <=  backgroundImageFrame.maxY
    }
    
    func newGestureCoords(point: CGPoint) -> CGPoint {
        let backgroundImageFrame = self.backgroundImage.frame
        
        if point.x < 0 {
            return CGPoint(x: point.x + 1, y: point.y)
        } else if(point.x > backgroundImageFrame.width) {
            return CGPoint(x: point.x - 1, y: point.y)
        } else if(point.y < backgroundImageFrame.minY){
            return CGPoint(x: point.x, y: point.y + 5)
        } else {
            return CGPoint(x: point.x, y: point.y - 1)
        }
    }
    
    @IBAction func fontSizeStepperChanged(_ sender: UIStepper) {
        quoteText.font = quoteText.font?.withSize(CGFloat(sender.value))
        adjustTextViewWidth(textView: quoteText)
        saveFontSize(size: sender.value)
        changeTextViewStyle()
        //quoteText.resignFirstResponder()
    }
    
    func saveLabelPostion(point: CGPoint){
        selectedPortfolioItem.x_position = Double(point.x)
        selectedPortfolioItem.y_position = Double(point.y)
        ad.saveContext()
    }
    
    func saveQuote(text: String) {
        selectedPortfolioItem.quote = text
        ad.saveContext()
    }
    
    func saveFontSize(size: Double){
        selectedPortfolioItem.font_size = Int64(size)
        ad.saveContext()
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
