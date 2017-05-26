# NKVPhonePicker

![Cocoapods](https://img.shields.io/badge/pod-available-brightgreen.svg?style=flat)
![Platform](https://img.shields.io/badge/platform-ios-blue.svg?style=flat)
![Version](https://img.shields.io/badge/version-0.1.0-blue.svg?style=flat)
![Swift version](https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat)
![License](https://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)

An UITextField subclass to simplify country code's picking.

## Preview
![](https://raw.githubusercontent.com/NikKovIos/NKVPhonePicker/master/RepoAssets/Example.gif)
![Screenshot_one](https://raw.githubusercontent.com/NikKovIos/NKVPhonePicker/master/RepoAssets/Screenshot_1.png "Screenshot_one")
![Screenshot_two](https://raw.githubusercontent.com/NikKovIos/NKVPhonePicker/master/RepoAssets/Screenshot_2_new.jpg "Screenshot_two")
![Screenshot_three](https://raw.githubusercontent.com/NikKovIos/NKVPhonePicker/master/RepoAssets/Screenshot_3.png.png "Screenshot_three")


## Installation

NKVPhonePicker is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ObjectMapper_RealmSwift'
```

## Usage

Make your UIPickerView a class of CountryPicker, set its countryPickerDelegate and implement its countryPhoneCodePicker method.
Example:
```
import CountryPicker

class ViewController: UIViewController, CountryPickerDelegate {

    @IBOutlet weak var picker: CountryPicker!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       //get corrent country
        let locale = Locale.current
        let code = (locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String?
        //init Picker
        picker.countryPickerDelegate = self
        picker.showPhoneNumbers = true
        picker.setCountry(code!)

    }
    
    // a picker item was selected
    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
       //pick up anythink
      code.text = phoneCode
    }

}
```

## Integration

#### CocoaPods (iOS 8+, OS X 10.9+)

CountryPicker is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your 'Podfile':

```ruby
platform :ios, '8.0'
use_frameworks!

target 'MyApp' do
    pod 'CountryPickerSwift'
end
```

#### Swift Package Manager

You can use [The Swift Package Manager](https://swift.org/package-manager) to install `CountryPicker` by adding the proper description to your `Package.swift` file:

```swift
import PackageDescription

let package = Package(
    name: "YOUR_PROJECT_NAME",
    targets: [],
    dependencies: [
        .Package(url: "git@github.com:4taras4/CountryCode.git")
    ]
)
```

Note that the [Swift Package Manager](https://swift.org/package-manager) is still in early design and development, for more information checkout its [GitHub Page](https://github.com/apple/swift-package-manager)

#### Manually

To use this library in your project manually just drag and drop CountryPicker folder to your project.

## Author

4taras4, 4taras4@gmail.com

## License

CountryPicker is available under the MIT license. See the LICENSE file for more info.
[release-link]: https://github.com/4taras4/CountryCode/releases/latest
