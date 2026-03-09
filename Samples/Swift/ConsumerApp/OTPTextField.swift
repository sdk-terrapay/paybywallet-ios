//
//  OTPTextField.swift
//  ConsumerApp
//
//  Created by Sunku Sneha on 04/11/25.
//

import Foundation
import UIKit

@objc class OTPTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initalizeUI() {
        autocorrectionType = .no
        textAlignment = .center
        textContentType = .oneTimeCode
    }
    
    override func deleteBackward() {
        super.deleteBackward()
        _ = delegate?.textField?(self, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: "")
    }
}
