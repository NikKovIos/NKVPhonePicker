//
// Be happy and free :)
//
// Nik Kov
// nik-kov.com
//

import UIKit

open class NKVFlagView: UIView {
    
    // MARK: - Interface
    
    /// Shows what country is presenting now.
    public var currentPresentingCountry: Country?

    
    /// Size of the flag icon
    public var iconSize: CGSize     { didSet { configureInstance() } }
    /// Shifting for the icon from top, left, bottom and right.
    public var insets: UIEdgeInsets { didSet { configureInstance() } }
    
    /// A designated method for setting a flag image
    public func setFlag(with source: NKVSource) {
        currentPresentingCountry = Country.country(for: source)
        
        let flagImage = NKVSourcesHelper.flag(for: source)
        self.flagButton.setImage(flagImage, for: .normal)
    }
    
    public required init(with textField: UITextField) {
        self.textField = textField
        self.insets = UIEdgeInsetsMake(7, 7, 7, 7)
        self.iconSize = CGSize(width: 18.0, height: textField.frame.height)
        super.init(frame: CGRect.zero)
        
        configureInstance()

        if let countryForCurrentPhoneLocalization = Country.currentCountry {
            setFlag(with: NKVSource(country: countryForCurrentPhoneLocalization))
        }
    }
    
    override open func layoutSubviews() {
        updateFrame()
    }
    
    
    
    
    // MARK: - Implementation
    
    private var flagButton: UIButton = UIButton()
    private weak var textField: UITextField!

    private func configureInstance() {
        // Adding flag button to flag's view
        flagButton.imageEdgeInsets = insets;
        flagButton.imageView?.contentMode = .scaleAspectFit
        flagButton.contentMode = .scaleToFill
        if flagButton.superview == nil { self.addSubview(flagButton) }
        
        updateFrame()
    }
    
    /// Set and update flag view's frame.
    private func updateFrame() {
        // Setting flag view's frame
        self.frame = CGRect(x: 0,
                            y: 0,
                            width: insets.left + insets.right + iconSize.width,
                            height: max(textField.frame.height, iconSize.height))
        flagButton.frame = self.frame
    }
    
    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) not supported"); }
}
