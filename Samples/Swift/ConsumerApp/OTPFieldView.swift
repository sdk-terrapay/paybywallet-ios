//
//  OTPFieldView.swift
//  ConsumerApp
//
//  Created by Sunku Sneha on 29/10/25.
//

import UIKit

protocol OTPFieldViewDelegate: AnyObject {
    func enteredOTP(otp: String)
    func hasEnteredAllOTP(hasEnteredAll: Bool)
}

class OTPFieldView: UIView {
    
    /// Different display type for text fields.
    var fieldsCount: Int = 4
    var fieldFont: UIFont = UIFont.boldSystemFont(ofSize: 18.0)
    var secureEntry: Bool = false
    var fieldSize: CGFloat = 60
    var separatorSpace: CGFloat = 16
    var shouldAllowIntermediateEditing: Bool = true
    var defaultBackgroundColor: UIColor = UIColor.clear
    var filledBackgroundColor: UIColor = UIColor.clear
    var placeHolderColor: UIColor = UIColor.lightGray
    var fieldTextColor: UIColor = UIColor.black
    var hasEnteredOTP = false
    var otpString: String = ""
    weak var delegate: OTPFieldViewDelegate?
    fileprivate var secureEntryData = [String]()
    fileprivate var currIndex = 0
    
    func initializeUI() {
        layer.masksToBounds = true
        layoutIfNeeded()
        
        initializeOTPFields()
        
        layoutIfNeeded()
    }
    
    func setText(with tag: Int) {
        
        hasEnteredOTP = false
        
        if 100 == tag {
            let textField = getOTPField(forIndex: currIndex)
            let currentText = textField.text ?? ""
            if textField.tag > 1 && currentText.isEmpty {
                if let prevOTPField = viewWithTag(textField.tag - 1) as? UITextField {
                    deleteText(in: prevOTPField)
                    currIndex -= 1
                }
            } else {
                deleteText(in: textField)
                if textField.tag > 1 {
                    if let _ = viewWithTag(textField.tag - 1) as? UITextField {
                        currIndex -= 1
                    }
                }
            }
        } else {
            let textField = viewWithTag(currIndex+1) as? OTPTextField
            
            if let otpField = textField {
                if secureEntry {
                    otpField.text = "●"
                } else {
                    otpField.text = String(tag)
                }
                
                secureEntryData[otpField.tag - 1] = String(tag)
                currIndex += 1
            }
        }
        
        if currIndex == fieldsCount {
            var enteredOTPString = ""
            
            if let textField = viewWithTag(currIndex) as? OTPTextField {
                if secureEntry {
                    textField.text = "●"
                } else {
                    textField.text = String(tag)
                }
            }
            
            // Check for entered OTP
            for index in stride(from: 0, to: secureEntryData.count, by: 1) where !secureEntryData[index].isEmpty {
                enteredOTPString.append(secureEntryData[index])
            }
            hasEnteredOTP = true
            otpString = enteredOTPString
            delegate?.enteredOTP(otp: enteredOTPString)
            delegate?.hasEnteredAllOTP(hasEnteredAll: true)
        }
    }
    
    fileprivate func initializeOTPFields() {
        secureEntryData.removeAll()
        
        for index in stride(from: 0, to: fieldsCount, by: 1) {
            let oldOtpField = viewWithTag(index + 1) as? OTPTextField
            oldOtpField?.removeFromSuperview()
            
            let otpField = getOTPField(forIndex: index)
            otpField.isUserInteractionEnabled = false
            addSubview(otpField)
            
            secureEntryData.append("")
        }
    }
    
    
    public func resetAllOTPFields() {
        
        for index in stride(from: 0, to: fieldsCount, by: 1) {
            
            var otpField = viewWithTag(index + 1) as? OTPTextField
            
            if otpField == nil {
                otpField = getOTPField(forIndex: index)
            }
            otpField?.text = ""
        }
        currIndex = 0
    }
    
    
    fileprivate func getOTPField(forIndex index: Int) -> OTPTextField {
        let hasOddNumberOfFields = (fieldsCount % 2 == 1)
        var fieldFrame = CGRect(x: 0, y: 0, width: fieldSize, height: fieldSize)
        
        if hasOddNumberOfFields {
            // Calculate from middle each fields x and y values so as to align the entire view in center
            fieldFrame.origin.x = bounds.size.width / 2 - (CGFloat(fieldsCount / 2 - index) * (fieldSize + separatorSpace) + fieldSize / 2)
        } else {
            // Calculate from middle each fields x and y values so as to align the entire view in center
            fieldFrame.origin.x = bounds.size.width / 2 - (CGFloat(fieldsCount / 2 - index) * fieldSize + CGFloat(fieldsCount / 2 - index - 1) * separatorSpace + separatorSpace / 2)
        }
        
        fieldFrame.origin.y = (bounds.size.height - fieldSize) / 2
        
        let otpField = OTPTextField(frame: fieldFrame)
        otpField.delegate = self
        otpField.tag = index + 1
        otpField.font = fieldFont
        
        // Set the default background color when text not set
        otpField.backgroundColor = defaultBackgroundColor
        
        // Finally create the fields
        otpField.initalizeUI()
        otpField.textColor = fieldTextColor
        otpField.attributedPlaceholder = NSAttributedString(string: "●", attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderText, NSAttributedString.Key.font:fieldFont])
        return otpField
    }
    
    fileprivate func isPreviousFieldsEntered(forTextField textField: UITextField) -> Bool {
        var isTextFilled = true
        var nextOTPField: UITextField?
        
        // If intermediate editing is not allowed, then check for last filled field in forward direction.
        if !shouldAllowIntermediateEditing {
            for index in stride(from: 1, to: fieldsCount + 1, by: 1) {
                let tempNextOTPField = viewWithTag(index) as? UITextField
                
                if let tempNextOTPFieldText = tempNextOTPField?.text, tempNextOTPFieldText.isEmpty {
                    nextOTPField = tempNextOTPField
                    break
                }
            }
            if let nextOTPField = nextOTPField {
                isTextFilled = (nextOTPField == textField || (textField.tag) == (nextOTPField.tag - 1))
            }
        }
        return isTextFilled
    }
    
    // Helper function to get the OTP String entered
    fileprivate func calculateEnteredOTPSTring(isDeleted: Bool) {
        hasEnteredOTP = false
        if isDeleted {
            delegate?.hasEnteredAllOTP(hasEnteredAll: false)
            
            // Set the default enteres state for otp entry
            for index in stride(from: 0, to: fieldsCount, by: 1) {
                var otpField = viewWithTag(index + 1) as? OTPTextField
                
                if otpField == nil {
                    otpField = getOTPField(forIndex: index)
                }
            }
        } else {
            var enteredOTPString = ""
            
            // Check for entered OTP
            for index in stride(from: 0, to: secureEntryData.count, by: 1) where !secureEntryData[index].isEmpty {
                enteredOTPString.append(secureEntryData[index])
            }
            
            if enteredOTPString.count == fieldsCount {
                hasEnteredOTP = true
                otpString = enteredOTPString
                delegate?.enteredOTP(otp: enteredOTPString)
                
                // Check if all OTP fields have been filled or not. Based on that call the 2 delegate methods.
                delegate?.hasEnteredAllOTP(hasEnteredAll: (enteredOTPString.count == fieldsCount))
                
                // Set the error state for invalid otp entry
                for index in stride(from: 0, to: fieldsCount, by: 1) {
                    var otpField = viewWithTag(index + 1) as? OTPTextField
                    if otpField == nil {
                        otpField = getOTPField(forIndex: index)
                    }
                }
            }
        }
    }
}

extension OTPFieldView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return isPreviousFieldsEntered(forTextField: textField)
    }
    
    private func deleteText(in textField: UITextField) {
        secureEntryData[textField.tag - 1] = ""
        textField.text = ""
        calculateEnteredOTPSTring(isDeleted: true)
    }
}
 
