//
// Be happy and free :)
//
// Nik Kov
// nik-kov.com
//

import Foundation
import UIKit

open class NKVPhonePickerTextField: TextFieldPatternFormat {
    
    // MARK: - Interface
    
    // MARK: Settings
    
    /// Set this property in order to present the CountryPickerViewController
    /// when user clicks on the flag button
    @IBOutlet public weak var phonePickerDelegate: UIViewController?

    /// Use this var for setting countries in the top of the tableView
    /// Ex:
    ///
    ///     textField.favoriteCountriesLocaleIdentifiers = ["RU", "JM", "GB"]
    public var favoriteCountriesLocaleIdentifiers: [String]?
    
    /// Use this var for setting custom phone formatting for countries. Use "#" char.
    /// Ex:
    ///
    ///     textField.customPhoneFormats = ["RU" : "# ### ### ## ##", "GB": "# #### #########"]
    public var customPhoneFormats: [String: String]?
    
    /// Set to 'false' if you don't need the '+' prefix
    public var isPlusPrefixExists: Bool = true {
        didSet {
            if isPlusPrefixExists == false {
                plusLabel?.removeFromSuperview()
                textFieldTextInsets = UIEdgeInsets.zero
            }
        }
    }
    
    /// Show is there a valid country flag (not with question mark).
    public var isFlagExist: Bool = false
    
    /// Set to 'false' if you don't need to scroll to selected country in CountryPickerViewController.
    public var shouldScrollToSelectedCountry: Bool = true
    
    // MARK: - Get
    
    /// Use this var to set or get current selected country.
    public var currentSelectedCountry: Country? {
        didSet {
            if let selected = currentSelectedCountry {
                self.setCode(country: selected)
                self.setFlag(country: selected)
            }
        }
    }
    
    /// The UIView subclass which contains flag icon.
    open var flagView: NKVFlagView!
    
    /// The UILabel with plus if isPlusPrefixExists == true
    open var plusLabel: UILabel?
    
    /// - Returns: Current phone number in textField without '+'. Ex: 79997773344.
    public var phoneNumber: String {
        return self.text?.cutSpaces.cutPluses ?? ""
    }
    
    /// - Returns: Current phone code without +. Ex: 7
    public var code: String {
        return flagView.currentPresentingCountry.phoneExtension.cutPluses
    }
    
    // MARK: - Set
    
    /// Method for set code in textField with Country entity.
    public func setCode(country: Country) {
        self.text = ""
        self.text = "\(country.phoneExtension)"
    }
    
    /// Method for set flag with countryCode.
    ///
    /// If nil it would be "?" code. This code present a flag with question mark.
    public func setFlag(countryCode: String?) {
        let country = Country.countryBy(countryCode: code)
        self.setFlag(country: country)
    }
    
    /// Method for set flag with Country entity.
    public func setFlag(country: Country) {
        let (exists, country) = NKVSourcesHelper.isFlagExistsWith(countryCode: country.countryCode)
        if exists {
            flagView.setFlagWith(countryCode: country.countryCode)
            if let customFormats = customPhoneFormats {
                for format in customFormats {
                    if country.countryCode.uppercased() == format.key {
                        self.setFormatting(format.value, replacementChar: "#")
                        return
                    }
                }
            }
            self.setFormatting(country.formatPattern, replacementChar: "#")
        }
    }
    
    /// Method for set flag with phone extenion.
    public func setFlag(phoneExtension: String) {
        let country = Country.countryBy(phoneExtension: phoneExtension)
        self.setFlag(country: country)
    }
    
    // MARK: - Customizing
    
    // Country picker customization properties:
    public var pickerTitle: String?
    public var pickerTitleFont: UIFont?
    public var pickerCancelButtonTitle: String?
    public var pickerCancelButtonColor: UIColor?
    public var pickerCancelButtonFont: UIFont?
    public var pickerBarTintColor: UIColor?
    
    /// Insets for text in textField
    public var textFieldTextInsets: UIEdgeInsets? { didSet { layoutSubviews() } }
    
    /// Insets for the flag icon.
    ///
    /// Left and right insets affect on flag view. 
    /// Top and bottom insets - on image only.
    public var flagInsets: UIEdgeInsets? { didSet { customizeSelf() } }
    public var flagSize: CGSize?         { didSet { customizeSelf() } }



    
    
    
    
    
    // MARK: - Implementation
    
    // MARK: Initialization
    // With code initialization you always must define textField's height 
    // in order to properly add a plus label.
    @available(*, unavailable)
    init() {
        super.init(frame: CGRect.zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        addPlusLabel()
    }
    
    private func initialize() {
        self.leftViewMode = .always
        self.keyboardType = .phonePad
        flagView = NKVFlagView(with: self)
        self.leftView = flagView
        self.delegate = self
        
        var fontSize = (self.font?.pointSize ?? 10) / 2
        fontSize = fontSize == 0 ? 5 : fontSize
        textFieldTextInsets = UIEdgeInsets(top: 0, left: fontSize, bottom: 0, right: 0)
        
        currentSelectedCountry = Country.currentCountry
        
        flagView.flagButton.addTarget(self, action: #selector(presentCountriesViewController), for: .touchUpInside)
        self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
   
    private func addPlusLabel() {
        if isPlusPrefixExists && (plusLabel == nil) {
            plusLabel = UILabel(frame: CGRect.zero)
            plusLabel?.backgroundColor = UIColor.clear
            plusLabel?.text = "+"
            self.addSubview(plusLabel!)
        }
        plusLabel?.font = self.font
        plusLabel?.textColor = self.textColor
        plusLabel?.frame = CGRect(x: self.flagView.frame.size.width,
                                  y: self.flagView.frame.origin.y,
                                  width: (self.font?.pointSize ?? 10) / 1.5,
                                  height: self.frame.size.height * 0.9)
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
            let fontAttributes = [NSAttributedStringKey.font: pickerTitleFont]
            navController.navigationBar.titleTextAttributes = fontAttributes
        }
        if let pickerCancelButtonFont = pickerCancelButtonFont {
            let fontAttributes = [NSAttributedStringKey.font: pickerCancelButtonFont]
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
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: UIEdgeInsetsInsetRect(bounds, textFieldTextInsets ?? UIEdgeInsets.zero))
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return super.editingRect(forBounds: UIEdgeInsetsInsetRect(bounds, textFieldTextInsets ?? UIEdgeInsets.zero))
    }
}

extension NKVPhonePickerTextField: CountriesViewControllerDelegate {
    public func countriesViewController(_ sender: CountriesViewController, didSelectCountry country: Country) {
        currentSelectedCountry = country
    }
    
    open func countriesViewControllerDidCancel(_ sender: CountriesViewController) {
        /// Do nothing yet
    }
}

extension NKVPhonePickerTextField: UITextFieldDelegate {
    @objc fileprivate func textFieldDidChange() {
        if let newString = self.text {
            if newString.count == 1 || newString.count == 0 {
                self.setFlag(countryCode: "?")
            }

            let firstFourLetters = String(newString.prefix(5))
            self.setFlag(phoneExtension: firstFourLetters)
        }
    }
}
