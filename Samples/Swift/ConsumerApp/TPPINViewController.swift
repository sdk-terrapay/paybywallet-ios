//
//  TPPINViewController.swift
//  ConsumerApp
//
//  Created by Sunku Sneha on 30/10/25.
//

import UIKit
import TerraPayWalletSDK

class TPPINViewController: UIViewController {

    @IBOutlet weak var lblMerchantName: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var viewSender: UIView!
    @IBOutlet weak var viewKeyBoard: UIView!
    @IBOutlet weak var pinFieldView: OTPFieldView!
    @IBOutlet weak var imgDelete: UIImageView!
    @IBOutlet weak var imgProceed: UIImageView!
    @IBOutlet weak var viewWarning: UIView!
    @IBOutlet var keyPadButtons: [UIButton]!

    private var enteredPINString: String?
    private var hasEnteredAll = false
    static let identifier = "TPPINViewController"
    var merchantInfo: TPMerchant?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUIView()
        setupOTPView()
    }

    private func setupUIView() {

        keyPadButtons.forEach({$0.titleLabel?.font = UIFont.custom(.bold, size: 20.0)})
        viewWarning.isHidden = true
        if let merchantName = merchantInfo?.merchantName,
           let subscriberCurrency = merchantInfo?.subscriberCurrency,
           let subscriberAmount = merchantInfo?.subscriberAmount {
            lblMerchantName.text = merchantName
            lblAmount.text = subscriberCurrency + " " + subscriberAmount
        }
        viewSender.layer.cornerRadius = 8
        viewWarning.isHidden = true
        handleButtonProceedUI(with: false)
    }

    private func setupOTPView() {
        pinFieldView.fieldTextColor = UIColor.primarycolor
        pinFieldView.placeHolderColor = UIColor.placeholderText
        pinFieldView.defaultBackgroundColor = .white
        pinFieldView.fieldSize = 15
        pinFieldView.separatorSpace = 30
        pinFieldView.shouldAllowIntermediateEditing = false
        pinFieldView.delegate = self
        pinFieldView.initializeUI()
    }
    

    private func handleButtonProceedUI(with enabled: Bool) {
        imgProceed.tintColor = enabled ? UIColor.primarycolor:UIColor.darkGray
    }

    @IBAction func handleNumberPadClicked(_ sender: UIButton) {
        pinFieldView.setText(with: sender.tag)
    }

    private func generateOrderId() -> String {
            let digits = Array("0123456789")
            let randomPart = String((0..<12).compactMap { _ in digits.randomElement() })
            return ("TP" + randomPart).uppercased()
        }
}

extension TPPINViewController: OTPFieldViewDelegate {
    func enteredOTP(otp: String) {
        TerraPayWalletClient.shared.processPayment(controller: self, transactionId: generateOrderId())
    }
    
    func hasEnteredAllOTP(hasEnteredAll: Bool) {
        
    }
}
