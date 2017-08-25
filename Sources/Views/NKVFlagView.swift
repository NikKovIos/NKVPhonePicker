//
// Be happy and free :)
//
// Nik Kov
// nik-kov.com
//

import UIKit

final class NKVFlagView: UIView {
    // MARK: - Interface
    /// Size of the flag icon
    public var iconSize: CGSize     { didSet { configureInstance() } }
    /// Shifting for the icon from top, left, bottom and right.
    public var insets: UIEdgeInsets { didSet { configureInstance() } }
    
    /// Shows what country is presenting now.
    public var currentPresentingCountry: Country = Country.empty
    
    public var flagButton: UIButton = UIButton()
    
    /// Convenience method to set the flag with Country entity.
    public func setFlagWith(country: Country) {
        self.setFlagWith(countryCode: country.countryCode)
    }
    
    /// Convenience method to set the flag with phone extension.
    public func setFlagWith(phoneExtension: String) {
        let country = Country.countryBy(phoneExtension: phoneExtension)
        self.setFlagWith(country: country)
    }
    
    /// Method for setting a flag with country (region) code.
    public func setFlagWith(countryCode: String?) {
        let code = countryCode ?? "?"
        
        currentPresentingCountry = Country.countryBy(countryCode: code)
        
        let flagImage = NKVSourcesHelper.getFlagImage(by: code)
        self.flagButton.setImage(flagImage, for: .normal)
        self.flagButton.imageView?.contentMode = .scaleAspectFit
    }
    
    public required init(with textField: UITextField) {
        self.textField = textField
        self.insets = UIEdgeInsetsMake(7, 7, 7, 7)
        self.iconSize = CGSize(width: 18.0, height: textField.frame.height)
        super.init(frame: CGRect.zero)
        configureInstance()
        setFlagWith(countryCode: NKVLocalizationHelper.currentCode)
    }
    
    override func layoutSubviews() {
        updateFrame()
    }
    
    // MARK: - Implementation
    private weak var textField: UITextField!

    private func configureInstance() {
        // Adding flag button to flag's view
        flagButton.imageEdgeInsets = insets;
        flagButton.contentMode = .scaleToFill
        if flagButton.superview == nil { self.addSubview(flagButton) }
        
        updateFrame()
    }
    
    /// Set and update flag view's frame.
    func updateFrame() {
        // Setting flag view's frame
        self.frame = CGRect(x: 0,
                            y: 0,
                            width: insets.left + insets.right + iconSize.width,
                            height: max(textField.frame.height, iconSize.height))
        flagButton.frame = self.frame
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) not supported"); }
}
