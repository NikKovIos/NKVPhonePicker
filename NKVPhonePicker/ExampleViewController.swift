//
// Be happy and free :)
//
// Nik Kov
// nik-kov.com
//

import UIKit

class ExampleViewController: UIViewController {
    
    @IBOutlet weak var topTextField: NKVPhonePickerTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topTextField.flagSize = CGSize(width: 30, height: 50)
    }
}
