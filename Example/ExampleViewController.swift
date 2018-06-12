//
// Be happy and free :)
//
// Nik Kov
// nik-kov.com
//

import UIKit

class ExampleViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var topTextField: NKVPhonePickerTextField!
    var bottomTextField: NKVPhonePickerTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topTextField.phonePickerDelegate = self
        topTextField.favoriteCountriesLocaleIdentifiers = ["RU", "ER", "JM"]
        
        /// Uncomment next line to try different settings
//        topTextField.rightToLeftOrientation = true
//        topTextField.shouldScrollToSelectedCountry = false
//        topTextField.flagSize = CGSize(width: 30, height: 50)
//        topTextField.enablePlusPrefix = false
//        NKVPhonePickerTextField.samePhoneExtensionCountryPriorities = ["1": "US"]
        
        // Setting initial custom country
        let country = Country.country(for: NKVSource(countryCode: "RU"))
        topTextField.country = country
        
        // Setting to let the flag be changed only with code
//        topTextField.isFlagFixed = true

        // Setting custom format pattern for some countries
        topTextField.customPhoneFormats = ["RU" : "# ### ### ## ##",
                                           "IN": "## #### #########"]
        
        // You can also add NKVPhonePickerTextField programmatically ;)
        addingProgrammatically()
        
        // For keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @IBAction func didPressPhoneNumber(_ sender: UIButton) {
        outputLabel.text = topTextField.phoneNumber
    }
    
    @IBAction func didPressCode(_ sender: UIButton) {
        outputLabel.text = topTextField.code
    }
    
    @IBAction func didPressCountry(_ sender: UIButton) {
        if let country = topTextField.country {
            outputLabel.text = "\(country.countryCode); \(country.name)"
        } else {
            print("The country not setted.")
        }
    }
    
    @IBAction func didPressOnView(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    /// You can add NKVPhonePickerTextField also programmatically
    func addingProgrammatically() {
        bottomTextField = NKVPhonePickerTextField(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
        bottomTextField.placeholder = "ex: 03123456"
        bottomTextField.autocorrectionType = .no
        bottomTextField.phonePickerDelegate = self
        bottomTextField.keyboardType = .numberPad
        bottomTextField.favoriteCountriesLocaleIdentifiers = ["LB"]
        bottomTextField.layer.borderWidth = 1
        bottomTextField.layer.borderColor = UIColor.white.cgColor
        bottomTextField.layer.cornerRadius = 5
        bottomTextField.font = UIFont.boldSystemFont(ofSize: 25)
        bottomTextField.textColor = UIColor.white
        bottomTextField.textFieldTextInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        bottomTextField.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(bottomTextField)
        
        let views: [String : Any] = ["bottomTextField": self.bottomTextField]
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat:
            "H:|-15-[bottomTextField]-15-|",
                                                                   options: [],
                                                                   metrics: nil,
                                                                   views: views)
        
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat:
            "V:|-(>=0)-[bottomTextField(30)]-15-|",
                                                                 options: [],
                                                                 metrics: nil,
                                                                 views: views)
        
        view.addConstraints(horizontalConstraints)
        view.addConstraints(verticalConstraints)
    }
    
    
    // MARK: - Keyboard handling
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
}
