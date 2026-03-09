//
//  ViewController.swift
//  ConsumerApp
//
//  Created by Sunku Sneha on 18/09/25.
//

import UIKit
import TerraPayWalletSDK

class ViewController: UIViewController {
    
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblNameCustomer: UILabel!
    @IBOutlet weak var lblNameShort: UILabel!
    @IBOutlet weak var lblMobileNum: UILabel!
    @IBOutlet weak var lblBalance: UILabel!
    
    static let identifier = "TPDashBoardViewController"
    let subscriberName = "TerraPay User"
    let msisdn = "766901491"
    let dialCode = "+256"
    let balance = "100000"
    let currencyCode = "KES"
    let countryCode = "KE"
    let countryName = "KENYA"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUPUIElements()
    }
    
    private func setUPUIElements() {
        viewHeader.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 14)
        viewContainer.setRadiusWithShadow()
        displayUserInfo()
    }
    
    private func displayUserInfo() {
        lblNameCustomer.text = subscriberName
        lblNameShort.text = "TU"
        lblMobileNum.text = "\(dialCode)\(msisdn)"
        lblBalance.text = "\(currencyCode)" + " " + "\(balance)"
    }
    
    @IBAction func handleViewTransactionsClicked(_ sender: Any) {
        if TPNetworkManager.networkStatus != .satisfied {
            TPNetworkManager.shared.showNoInternetAlert(with: self)
            return
        }
    }
    
    @IBAction func handleMerchantPaymentsClicked(_ sender: Any) {
        
        let config = TerraPayWalletSDKConfig(controller: self,
                                             subscriberDialCode: dialCode,
                                             subscriberCountry: countryCode,
                                             subscriberCountryName: countryName,
                                             subscriberName: subscriberName,
                                             subscriberMSISDN: msisdn,
                                             subscriberCurrency: currencyCode,
                                             walletBalance: balance,
                                             primaryColor: "52B44A",
                                             secondaryColor: "FFFFFF")
        
        TerraPayWalletClient.shared.launch(with: config) { type, error, merchantDetails, status  in
            switch type {
            case .onPINAuthenticate:
                guard let merchantDetails = merchantDetails else { return }
                self.showTargetHostScreen(merchantDetails)
                break
            case .onError:
                if let errmsg = error?.message {
                    self.showToast(message: errmsg)
                }
            case .cancelled:
                self.showToast(message: "User cancelled.")
            case .onPaymentSuccess:
                print("Base app: \(status?.description)")
            case .onPaymentFailure:
                guard let error = error else{
                    self.showToast(message: "Something went wrong.")
                    return
                }
                self.showToast(message: error.message)
            default:
                self.showToast(message: "something went wrong.")
            }
        }
    }
    
    private func showTargetHostScreen(_ merchant: TPMerchant) {
        let stb = UIStoryboard.init(name: "Main", bundle: nil)
        if let targetVC = stb.instantiateViewController(withIdentifier: TPPINViewController.identifier) as? TPPINViewController {
            targetVC.modalPresentationStyle = .fullScreen
            targetVC.merchantInfo = merchant
            present(targetVC, animated: true)
        }
    }
}




extension UIViewController {
    func showToast(message: String) {
        
        var msgSize = message.sizeForView(font: UIFont.custom(.regular, size: 13.0), width: CGFloat.greatestFiniteMagnitude, height: 35)
        msgSize.width += 20
        
        if msgSize.width > UIScreen.main.bounds.width-40 {
            msgSize.width = UIScreen.main.bounds.width-40
        }
        
        let toastLabel = UILabel(frame: CGRect(x: (self.view.frame.size.width-msgSize.width)/2, y: self.view.frame.size.height-100, width: msgSize.width, height: 35))
        toastLabel.backgroundColor = UIColor.darkGray
        toastLabel.textColor = UIColor(named: "buttonFG")
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.custom(.regular, size: 13.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(_) in
            toastLabel.removeFromSuperview()
        })
    }
}

extension String {
    
    func sizeForView(font: UIFont, width: CGFloat, height: CGFloat) -> CGSize {
        
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = self
        
        label.sizeToFit()
        return label.frame.size
    }
}
