//
// Be happy and free :)
//
// Nik Kov
// nik-kov.com
//

import UIKit

class ExampleViewController: UIViewController {
    
    @IBOutlet weak var topTextField: NKVPhonePickerTextField!
    var bottomTextField: NKVPhonePickerTextField!
    
    @IBOutlet weak var outputLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topTextField.favoriteCountriesLocaleIdentifiers = ["RU", "ER", "JM"]
//        topTextField.shouldScrollToSelectedCountry = false
//        topTextField.flagSize = CGSize(width: 30, height: 50)
//        topTextField.setFlag(countryCode: nil)
//        topTextField.isPlusPrefixExists = false

        // Setting initial custom country
        let country = Country.countryBy(countryCode: "EG")
        topTextField.currentSelectedCountry = country

        // Setting custom format pattern for some countries
        topTextField.customPhoneFormats = ["RU" : "# ### ### ## ##",
                                           "GB": "## #### #########"]
        
        // You can also add NKVPhonePickerTextField programmatically ;)
        addingProgrammatically()
    }
    
    @IBAction func didPressPhoneNumber(_ sender: UIButton) {
        outputLabel.text = topTextField.phoneNumber
    }
    @IBAction func didPressCode(_ sender: UIButton) {
        outputLabel.text = topTextField.code
    }
    @IBAction func didPressOnView(_ sender: UITapGestureRecognizer) {
        self.topTextField.resignFirstResponder()
    }
    
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
        self.view.addSubview(bottomTextField)
        
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
}
