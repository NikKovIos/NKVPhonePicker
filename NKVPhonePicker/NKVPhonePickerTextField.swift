//
// Be happy and free :)
//
// Nik Kov
// nik-kov.com
//

import UIKit

public class NKVPhonePickerTextField: UITextField {
    // MARK: - Interface
    /// Set this property in order to present the CountryPickerViewController
    /// when user clicks on the flag button
    @IBOutlet weak var phonePickerDelegate: UIViewController?

    /// - Returns: Current phone number in textField with spaces. Ex: +7 999 777 33 44
    public var rawPhoneNumber: String {
        return self.text ?? ""
    }
    
    /// - Returns: Current phone number in textField. Ex: +79997773344.
    public var phoneNumber: String {
        return self.text?.replacingOccurrences(of: " ", with: "") ?? ""
    }
    
    /// - Returns: Current phone number in textField without code. Ex: 9997773344.
    public var phoneNumberWithoutCode: String {
        return (self.text?.replacingOccurrences(of: (currentSelectedCountry?.phoneExtension)!, with: ""))!
    }
    
    /// - Returns: Current phone code without +. Ex: 7
    public var code: String {
        return currentSelectedCountry?.phoneExtension.replacingOccurrences(of: "+", with: "") ?? ""
    }
    
    public var pickerTitle: String?
    public var pickerTitleFont: UIFont?
    public var pickerCancelButtonTitle: String?
    public var pickerCancelButtonColor: UIColor?
    public var pickerCancelButtonFont: UIFont?
    public var pickerBarTintColor: UIColor?
    
    /// Insets for the flag icon.
    ///
    /// Left and right insets affect on flag view. 
    /// Top and bottom insets - on image only.
    public var flagInsets: UIEdgeInsets? { didSet { customizeSelf() } }
    public var flagSize: CGSize?         { didSet { customizeSelf() } }
    
    /// The UIView subclass which contains flag icon. 
    var flagView: NKVFlagView!
    
    /// This var returnes an entity of current selected country.
    public var currentSelectedCountry: Country? {
        didSet {
            if let selected = currentSelectedCountry {
                self.setCode(with: selected)
                flagView.setFlagWith(country: selected)
            }
        }
    }
    
    /// Use this var for setting countries in the top of the tableView
    /// Ex:
    ///
    ///     countryVC.favoriteCountriesLocaleIdentifiers = ["RU", "JM", "GB"]   
    public var favoriteCountriesLocaleIdentifiers: [String]?
    
    /// Set to 'false' if you want to make available to erase the plus character
    /// while editing the textField.
    public var isPlusPrefixImmortal: Bool = true
    
    /// Set to 'false' if you don't need to scroll to selected country in CountryPickerViewController
    public var shouldScrollToSelectedCountry: Bool = true
    
    /// Method for set code in textField with Country entity
    public func setCode(with country: Country) {
        self.text = "+\(country.phoneExtension) "
    }
    
    /// Method for set flag with countryCode
    ///
    /// If nil it would be "?" code. This code present a flag with question mark.
    public func setFlag(countryCode: String?) {
        flagView.setFlag(with: countryCode)
    }
    
    // MARK: - Implementation
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        self.leftViewMode = .always;
        self.keyboardType = .numberPad
        flagView = NKVFlagView(with: self)
        self.leftView = flagView
        self.delegate = self
        
        currentSelectedCountry = Country.currentCountry
        
        flagView.flagButton.addTarget(self, action: #selector(presentCountriesViewController), for: .touchUpInside)
    }
    
    /// Presents a view controller to choose a country code.
    @objc private func presentCountriesViewController() {
        if let delegate = phonePickerDelegate {
            let countriesVC = CountriesViewController.standardController()
            countriesVC.delegate = self as CountriesViewControllerDelegate
            let navC = UINavigationController.init(rootViewController: countriesVC)
            
            customizeCountryPicker(countriesVC)
            delegate.present(navC, animated: true, completion: nil)
        }
    }
    
    // MARK: Customization
    /// Method to customize the CountryPickerController.
    private func customizeCountryPicker(_ pickerVC: CountriesViewController) {
        pickerVC.shouldScrollToSelectedCountry = shouldScrollToSelectedCountry
        
        if let currentSelectedCountry = currentSelectedCountry {
            pickerVC.selectedCountry = currentSelectedCountry
        }
        if let favoriteCountriesLocaleIdentifiers = favoriteCountriesLocaleIdentifiers {
            pickerVC.favoriteCountriesLocaleIdentifiers = favoriteCountriesLocaleIdentifiers
        }
        if let pickerTitle = pickerTitle {
            pickerVC.countriesVCNavigationItem.title = pickerTitle
        }
        if let pickerTitleFont = pickerTitleFont, let navController = pickerVC.navigationController {
            let fontAttributes = [NSFontAttributeName: pickerTitleFont]
            navController.navigationBar.titleTextAttributes = fontAttributes
        }
        if let pickerCancelButtonFont = pickerCancelButtonFont {
            let fontAttributes = [NSFontAttributeName: pickerCancelButtonFont]
            pickerVC.countriesVCNavigationItem.leftBarButtonItem?.setTitleTextAttributes(fontAttributes, for: .normal)
            pickerVC.countriesVCNavigationItem.leftBarButtonItem?.setTitleTextAttributes(fontAttributes, for: .highlighted)
        }
        if let pickerCancelButtonTitle = pickerCancelButtonTitle {
            pickerVC.countriesVCNavigationItem.leftBarButtonItem?.title = pickerCancelButtonTitle
        }
        if let pickerCancelButtonColor = pickerCancelButtonColor {
            pickerVC.countriesVCNavigationItem.leftBarButtonItem?.tintColor = pickerCancelButtonColor
        }
        if let pickerBarTintColor = pickerBarTintColor, let navController = pickerVC.navigationController {
            navController.navigationBar.barTintColor = pickerBarTintColor
        }
    }
    
    private func customizeSelf() {
        if let flagInsets = flagInsets {
            flagView.insets = flagInsets
        }
        if let flagSize = flagSize {
            flagView.iconSize = flagSize
        }
    }
}

extension NKVPhonePickerTextField: CountriesViewControllerDelegate {
    public func countriesViewController(_ sender: CountriesViewController, didSelectCountry country: Country) {
        currentSelectedCountry = country
    }
    public func countriesViewControllerDidCancel(_ sender: CountriesViewController) {
        /// Do nothing yet
    }
}

extension NKVPhonePickerTextField: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        
        // Preventing of deleting a '+' character
        if updatedString?.characters.count == 0 && isPlusPrefixImmortal {
            textField.text = "+"
            return false
        }

        // Defining if there a prefix and if it - checking the country
        
//        let phonePrefix =
//        let phone =
        
        return true
    }
}
