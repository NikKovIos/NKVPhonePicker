//
// Be happy and free :)
//
// Nik Kov
// nik-kov.com
//

import UIKit

open class NKVFlagView: UIView {
    
    // MARK: - Interface
    
    /// Shows what country is presenting now. The NKVPhoneTextField gets its value for `country` property from here.
    public var currentPresentingCountry: Country?

    /// A designated method for setting a flag image
    public func setFlag(with source: NKVSource) {
        if let flagImage = NKVSourcesHelper.flag(for: source),
            let newSettedCountry = Country.country(for: source) {
            self.flagButton.setImage(flagImage, for: .normal)
            currentPresentingCountry = newSettedCountry
            textField.presenter.enablePhoneFormat(for: newSettedCountry)
        }
    }
    
    /// Size of the flag icon
    public var iconSize: CGSize     { didSet { configureInstance() } }
    /// Shifting for the icon from top, left, bottom and right.
    public var insets: UIEdgeInsets { didSet { configureInstance() } }
    
    // MARK: - Initialization

    public required init(with textField: NKVPhonePickerTextField) {
        self.textField = textField
        self.insets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        self.iconSize = CGSize(width: 18.0, height: textField.frame.height)
        super.init(frame: CGRect.zero)
        
        configureInstance()
    }
    
    override open func layoutSubviews() {
        updateFrame()
    }
    
    // MARK: - Implementation
    
    public var flagButton: UIButton = UIButton()
    private weak var textField: NKVPhonePickerTextField!

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
        self.frame = CGRect(x: 0,
                            y: 0,
                            width: insets.left + insets.right + iconSize.width,
                            height: max(textField.frame.height, iconSize.height))
        flagButton.frame = self.frame
    }
    
    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) not supported"); }
}
