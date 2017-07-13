//
//  EditPortfolioItemVC.swift
//  natalie-app-2
//
//  Created by Munene Kaumbutho on 2017-05-24.
//  Copyright © 2017 Munene Kaumbutho - Evan Zhang. All rights reserved.
//

import UIKit

class EditPortfolioItemVC: UIViewController, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
    //let filters = CIFilter.filterNames(inCategory: "CICategoryBlur") + CIFilter.filterNames(inCategory: "CICategoryColorAdjustment")
    //let filters = CIFilter.filterNames(inCategory: "CICategoryColorAdjustment")
    let filters = [
        "CIPhotoEffectChrome",
        "CIPhotoEffectFade",
        "CIPhotoEffectInstant",
        "CIPhotoEffectNoir",
        "CIPhotoEffectProcess",
        "CIPhotoEffectTonal",
        "CIPhotoEffectTransfer",
        "CISepiaTone",
        "CIGaussianBlur",
        "CICMYKHalftone",
        "CICrystallize"
    ]
    let ciContext = CIContext(options: nil)
    
    var quoteText = UITextView()
    var imageQuoteLabel = UILabel()
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var fontSizeStepper: UIStepper!
    @IBOutlet weak var fontPicker: UIPickerView!
    @IBOutlet weak var colorSlider: UISlider!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    @IBOutlet weak var fontSizeStackView: UIStackView!
    @IBOutlet weak var fontFamilyStackView: UIStackView!
    @IBOutlet weak var colorSliderStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        quoteText.delegate = self
        
        fontSizeStepper.wraps = true
        fontSizeStepper.autorepeat = true
        fontSizeStepper.maximumValue = 36
        
        fontPicker.delegate = self
        fontPicker.dataSource = self
        
        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        //layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        filterCollectionView.collectionViewLayout = layout
        
        navigationBar.topItem.title = "edit \(selectedBackground.name)"
        
        let imageData = selectedPortfolioItem.image?.img
        backgroundImage.image = UIImage(data: imageData! as Data)
        //backgroundImage.image = UIImage(contentsOfFile: selectedBackground.imageURL)
        
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
        
        fontSizeStackView.isHidden = true
        fontFamilyStackView.isHidden = true
        colorSliderStackView.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        changeTextViewStyle()
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        saveQuote(text: textView.text)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as? FilterCell {
            let thumbnail = selectedPortfolioItem.image?.thumbnail
            let thumbnailImage = UIImage(data: (thumbnail!) as Data)
            let filteredImage = addFilterToImage(image: thumbnailImage! , filter: filters[indexPath.row])
            //let filteredImage = addFilterToImage(image: backgroundImage.image!, filter: filters[indexPath.row])
            
            //cell.configureCell(filterImage: backgroundImage.image!)
            cell.configureCell(filterImage: filteredImage)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        
        let cells = collectionView.visibleCells as! [FilterCell]
        
        for cell in cells {
            let filterCell = cell.filterImageView
            filterCell?.layer.borderWidth = 0
            filterCell?.layer.borderColor = nil
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! FilterCell
        let cellImageView = cell.filterImageView
        cellImageView?.layer.borderColor = UIColor.blue.cgColor
        cellImageView?.layer.borderWidth = 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentFilter = filters[indexPath.row]
        saveFilter(filter: currentFilter)
        //let filteredImage = addFilterToImage(image: backgroundImage.image!, filter: currentFilter)
        let imageData = selectedPortfolioItem.image?.img
        let filteredImage = addFilterToImage(image: UIImage(data: imageData! as Data)!, filter: currentFilter)
        
        backgroundImage.image = filteredImage
        
        //let cell = collectionView.cellForItem(at: indexPath) as! FilterCell
        //backgroundImage.image = cell.filterImageView.image
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 65.0, height: 65.0)
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
    
    func addFilterToImage(image: UIImage, filter: String) -> UIImage {
        let coreImage = CIImage(image: image)
        let filter = CIFilter(name: filter)
        
        // set all filters values as default
        filter!.setDefaults()
        
        // give our filter an image and also a key: KCInputImageKey is a key fo a CIImage object used an an input image.
        filter!.setValue(coreImage, forKey: kCIInputImageKey)
        
        // return the value related to the kCIInputImageKey that has just been set above.
        let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
        let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
        
        return UIImage(cgImage: filteredImageRef!)
    }
    
    func changeTextViewStyle() {
        let range = NSRange(location: 0, length: quoteText.text.characters.count)
        let attributedText = NSMutableAttributedString(string: quoteText.text)
        let text = NSMutableParagraphStyle()
        text.alignment = .center
        attributedText.addAttributes([NSBackgroundColorAttributeName: UIColor.black, NSForegroundColorAttributeName: quoteText.textColor!, NSFontAttributeName: UIFont(name:(quoteText.font?.familyName)!, size: (quoteText.font?.pointSize)!)!, NSParagraphStyleAttributeName: text ], range: range)
        quoteText.attributedText = attributedText
        //quoteText.tintColor = .white
    }
    
    func unchangeTextViewStyle() {
        let range = NSRange(location: 0, length: quoteText.text.characters.count)
        let attributedText = NSMutableAttributedString(string: quoteText.text)
        let text = NSMutableParagraphStyle()
        text.alignment = .center
        attributedText.addAttributes([NSForegroundColorAttributeName: quoteText.textColor!, NSFontAttributeName: UIFont(name:(quoteText.font?.familyName)!, size: (quoteText.font?.pointSize)!)!, NSParagraphStyleAttributeName: text ], range: range)
        quoteText.attributedText = attributedText
        //quoteText.tintColor = .white
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
    
    @IBAction func discardBtnPressed(_ sender: Any) {
        
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        
    }
    
    
    @IBAction func colorSliderChanged(_ sender: UISlider) {
        let newColor = uiColorFromHex(rgbValue: colors[Int(sender.value)])
        quoteText.textColor = newColor
        saveFontColor(colorInt: colors[Int(sender.value)])
    }
    
    func uiColorFromHex(rgbValue: Int) -> UIColor {
        let red =   CGFloat((rgbValue & 0xFF0000) >> 16) / 0xFF
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 0xFF
        let blue =  CGFloat(rgbValue & 0x0000FF) / 0xFF
        let alpha = CGFloat(1.0)
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    @IBAction func segmentTapped(_ sender: Any) {
        if segment.selectedSegmentIndex == 0 {
            filterCollectionView.isHidden = false
            fontSizeStackView.isHidden = true
            fontFamilyStackView.isHidden = true
            colorSliderStackView.isHidden = true
        } else {
            filterCollectionView.isHidden = true
            fontSizeStackView.isHidden = false
            fontFamilyStackView.isHidden = false
            colorSliderStackView.isHidden = false
        }
        
    }
    
    @IBAction func fontSizeStepperChanged(_ sender: UIStepper) {
        quoteText.font = quoteText.font?.withSize(CGFloat(sender.value))
        adjustTextViewWidth(textView: quoteText)
        saveFontSize(size: sender.value)
        //changeTextViewStyle()
    }
    
    func saveFilter(filter: String){
        selectedPortfolioItem.filter_type = filter
        ad.saveContext()
    }
    
    func saveLabelPostion(point: CGPoint){
        selectedPortfolioItem.x_position = Double(point.x)
        selectedPortfolioItem.y_position = Double(point.y)
        ad.saveContext()
    }
    
    func saveFontFamily(font: UIFont){
        selectedPortfolioItem.font_family = font.familyName
        ad.saveContext()
    }
    
    func saveFontColor(colorInt: Int){
        selectedPortfolioItem.font_color = Int64(colorInt)
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
