//
//  NKVPhonePickerTextField.swift
//  NKVPhonePicker
//
//  Created by Nik Kov on 23.05.17.
//  Copyright © 2017 nik.kov. All rights reserved.
//

import UIKit

class NKVPhonePickerTextField: UITextField {
    var flagView: NKVFlagView!
    @IBOutlet weak var phonePickerDelegate: UIViewController?
    
    
    var pickerTitle: String?
    var pickerTitleFont: UIFont?
    var pickerCancelButtonTitle: String?
    var pickerCancelButtonColor: UIColor?
    var pickerCancelButtonFont: UIFont?
    var pickerBarTintColor: UIColor?
    //    @IBInspectable var
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        self.leftViewMode = .always;
        self.keyboardType = .numberPad
        flagView = NKVFlagView(with: self)
        self.leftView = flagView
        
        flagView!.flagButton.addTarget(self, action: #selector(presentCountriesViewController), for: .touchUpInside)
    }
    
    @objc private func presentCountriesViewController() {
        if let delegateVC = phonePickerDelegate {
            let countriesVC = CountriesViewController.standardController()
            if delegateVC is CountriesViewControllerDelegate {
                countriesVC.delegate = delegateVC as? CountriesViewControllerDelegate
            }
            let navC = UINavigationController.init(rootViewController: countriesVC)
            
            customizeCountryPicker(countriesVC)
            
            delegateVC.present(navC, animated: true, completion: nil)
        }
    }
    
    private func customizeCountryPicker(_ pickerVC: CountriesViewController) {
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
}
