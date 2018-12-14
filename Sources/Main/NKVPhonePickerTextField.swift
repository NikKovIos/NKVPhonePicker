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
    
    /// Use this var for setting priority of countries when they have the same phone extension
    /// Ex:
    ///
    ///     NKVPhonePickerTextField.samePhoneExtensionCountryPriorities = ["1": "US"]
    public static var samePhoneExtensionCountryPriorities: [String: String]?

    /// Use this var for setting countries in the top of the tableView
    /// Ex:
    ///
    ///     textField.favoriteCountriesLocaleIdentifiers = ["RU", "JM", "GB"]
    public var favoriteCountriesLocaleIdentifiers: [String]?
    
    /// Use this var for setting custom phone formatting for countries. Use "#" char.
    /// Ex:
    ///
    ///     textField.customPhoneFormats = ["RU" : "# ### ### ## ##", "GB": "# #### #########"]
    public var customPhoneFormats: [String: String]? { didSet { presenter.didSetCustomPhoneFormats() } }
    
    /// Set to 'false' if you don't need the '+' prefix to be visible
    public var enablePlusPrefix: Bool = true { didSet { presenter.plusPrefix(on: enablePlusPrefix) } }
    
    /// Set to 'false' if you don't need to scroll to selected country in when CountryPickerViewController did appear.
    public var shouldScrollToSelectedCountry: Bool = true
    
    /// Set to true for languages where flag and + must be at the right. For example for Arabic.
    public var rightToLeftOrientation: Bool = false { didSet { presenter.isRightToLeftMode(on: rightToLeftOrientation) } }
    
    /// If true the flag icon and country can be changed only by code. For ex: topTextField.country = Country.country(for: NKVSource(countryCode: "EG"))
    public var isFlagFixed: Bool = false
    
    // MARK: - Get
    
    /// Current selected country in TextField
    /// Use this var to set or get current selected country.
    /// nil if non country is selected
    public var country: Country? {
        get {
            return flagView.currentPresentingCountry
        }
        set {
            if let newValue = newValue {
                presenter.setCountry(source: NKVSource(country: newValue))
            }
        }
    }
    
    /// - Returns: Current phone number in textField without '+'. Ex: 79997773344.
    public var phoneNumber: String? {
        return self.text?.cutSpaces.cutPluses
    }
    
    /// - Returns: Current phone code without +. Ex: 7
    public var code: String? {
        return country?.phoneExtension
    }
    
    /// The UIView subclass which contains flag icon.
    open var flagView: NKVFlagView!
    
    /// The UILabel with plus if enablePlusPrefix == true
    open var plusLabel: UILabel?
    
    // MARK: - Set
    
    public func setCode(source: NKVSource) {
       presenter.setCode(source: source)
    }
    
    public func setFlag(source: NKVSource) {
        presenter.setFlag(source: source)
    }
    
    // MARK: - Customizing
    
    // MARK: Country Picker
    
    public var pickerTitle: String?
    public var pickerTitleFont: UIFont?
    public var pickerCancelButtonTitle: String?
    public var pickerCancelButtonColor: UIColor?
    public var pickerCancelButtonFont: UIFont?
    public var pickerBarTintColor: UIColor?
    
    // MARK: Text Field

    /// Insets for text in textField
    public var textFieldTextInsets: UIEdgeInsets? { didSet { layoutSubviews() } }
    
    /// Insets for the flag icon.
    ///
    /// Left and right insets affect on flag view. 
    /// Top and bottom insets - on image only.
    public var flagInsets: UIEdgeInsets? { didSet { customizeSelf() } }
    
    /// Size of the flag icon
    public var flagSize: CGSize?         { didSet { customizeSelf() } }



    
    
    
    
    
    // MARK: - Implementation
    
    // MARK: Initialization
    // With code initialization you always must define textField's height 
    // in order to properly add a plus label.
    @available(*, unavailable)
    init() {
        super.init(frame: CGRect.zero)
    }

    override public init(frame: CGRect) {
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
        flagView = NKVFlagView(with: self)
        self.keyboardType = .phonePad
        self.delegate = self
        flagView.flagButton.addTarget(self, action: #selector(presentCountriesViewController), for: .touchUpInside)
        self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        presenter.isRightToLeftMode(on: false)
        
        if let countryForCurrentPhoneLocalization = Country.currentCountry {
            country = countryForCurrentPhoneLocalization
        }
    }
   
    private func addPlusLabel() {
        if enablePlusPrefix && (plusLabel == nil) {
            plusLabel = UILabel(frame: CGRect.zero)
            plusLabel?.backgroundColor = UIColor.clear
            plusLabel?.text = "+"
            self.addSubview(plusLabel!)
        }
        plusLabel?.font = self.font
        plusLabel?.textColor = self.textColor
        
        // Setting a plus label frame
        let width = (self.font?.pointSize ?? 10) / 1.5
        var x = self.flagView.bounds.width
        if rightToLeftOrientation {
            x = self.bounds.width - width - self.flagView.bounds.width
        }
        plusLabel?.frame = CGRect(x: x,
                                  y: self.flagView.frame.origin.y,
                                  width: width,
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
        
        if let currentSelectedCountry = country {
            pickerVC.selectedCountry = currentSelectedCountry
        }
        if let favoriteCountriesLocaleIdentifiers = favoriteCountriesLocaleIdentifiers {
            pickerVC.favoriteCountriesLocaleIdentifiers = favoriteCountriesLocaleIdentifiers
        }
        if let pickerTitle = pickerTitle {
            pickerVC.countriesVCNavigationItem.title = pickerTitle
        }
        if let pickerTitleFont = pickerTitleFont, let navController = pickerVC.navigationController {
            let fontAttributes = [NSAttributedString.Key.font: pickerTitleFont]
            navController.navigationBar.titleTextAttributes = fontAttributes
        }
        if let pickerCancelButtonFont = pickerCancelButtonFont {
            let fontAttributes = [NSAttributedString.Key.font: pickerCancelButtonFont]
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
        return super.textRect(forBounds: bounds.inset(by: textFieldTextInsets ?? UIEdgeInsets.zero))
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return super.editingRect(forBounds: bounds.inset(by: textFieldTextInsets ?? UIEdgeInsets.zero))
    }
    
    /// Presenter class for business logic
    lazy var presenter: NKVPhonePickerPresenter = NKVPhonePickerPresenter(textField: self)
}

extension NKVPhonePickerTextField: CountriesViewControllerDelegate {
    public func countriesViewController(_ sender: CountriesViewController, didSelectCountry country: Country) {
        if isFlagFixed == false {
            self.country = country
        }
    }
    
    open func countriesViewControllerDidCancel(_ sender: CountriesViewController) {
        /// Overridable
    }
}

extension NKVPhonePickerTextField: UITextFieldDelegate {
    @objc fileprivate func textFieldDidChange() {
        if let newString = self.text, isFlagFixed == false {
            if newString.count == 1 || newString.count == 0 {
                self.setFlag(source: NKVSource(country: Country.empty))
            }
            
            let firstFourLetters = String(newString.prefix(5))
            self.setFlag(source: NKVSource(phoneExtension: firstFourLetters))
        }
    }
}
