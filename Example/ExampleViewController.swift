//
// Be happy and free :)
//
// Nik Kov
// nik-kov.com
//

import UIKit

class ExampleViewController: UIViewController {
    
    @IBOutlet weak var topTextField: NKVPhonePickerTextField!
    @IBOutlet weak var outputLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        topTextField.flagSize = CGSize(width: 30, height: 50)
        topTextField.favoriteCountriesLocaleIdentifiers = ["RU", "ER", "JM"]
//        topTextField.setFlag(countryCode: nil)
//        topTextField.isPlusPrefixImmortal = false
        topTextField.shouldScrollToSelectedCountry = false
    }
    @IBAction func didPressRawPhoneNumber(_ sender: UIButton) {
       outputLabel.text = topTextField.rawPhoneNumber
    }
    
    @IBAction func didPressPhoneNumber(_ sender: UIButton) {
        outputLabel.text = topTextField.phoneNumber
    }
    
    @IBAction func didPressPhoneNumberWithoutCode(_ sender: UIButton) {
        outputLabel.text = topTextField.phoneNumberWithoutCode
    }

    @IBAction func didPressCode(_ sender: UIButton) {
        outputLabel.text = topTextField.code
    }
    @IBAction func didPressOnView(_ sender: UITapGestureRecognizer) {
        self.topTextField.resignFirstResponder()
    }
}
