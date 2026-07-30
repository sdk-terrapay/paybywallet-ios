## 📦 TerraPaySDK

This SDK, provided by TerraPay, enables seamless payment transactions between customers and merchants through the partner mobile application. It supports multiple payment methods, including QR code scanning and merchant ID–based payments, and is designed for easy integration with iOS platform.

## 🚀 Features

- QR Code and Merchant ID Payments.
- Customizable User Experience with brand colors.
- Launch SDK with a single entry point.
- Easily embeddable into any iOS app.

## 🔐 Authentication (OAuth2)

TerraPay SDK requires OAuth2 authentication.
The partner application must generate both access token and refresh token using the client_credentials flow before launching the SDK.

Token Generation Endpoint

```swift
POST https://uat-connect.terrapay.com:27211/eig/getToken?subscriberid=subscriberMSISDN
```

cURL Request
```swift
curl --location 'https://uat-connect.terrapay.com:27211/eig/getToken?subscriberid=subscriberMSISDN' \
--header 'user: MTNSDK#UAT' \
--header 'password: b80e8ebf1943516770a2b1b6883070f8'
```

Sample Response
```swift
{
  "status" : "OK",
  "subStatus" : "Success",
  "access_token" : "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJKd3RUb2tlbiIsImlzcyI6IlRlcnJhUGF5IiwiaWF0IjoxNzg1NDE2MzAxLCJleHAiOjE3ODU0MTY2MDEsInBheWxvYWQiOiJtdG5zZGthcHBzIn0.CuVURSqFSPgSLSci1a0XoGoExEu3LkzR9ErkWhIj_y4",
  "refresh_token" : "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJKd3RUb2tlbiIsImlzcyI6IlRlcnJhUGF5IiwiaWF0IjoxNzg1NDE2MzAxLCJleHAiOjE3ODU1MDI3MDEsInBheWxvYWQiOiJ7XG4gIFwidXNlclwiIDogXCJNVE5TREsjVUFUXCIsXG4gIFwicGFzc3dvcmRcIiA6IFwiYjgwZThlYmYxOTQzNTE2NzcwYTJiMWI2ODgzMDcwZjhcIixcbiAgXCJzdWJzY3JpYmVyaWRcIiA6IFwiIDI1NDQ3Njg2NDgxMlwiXG59XG4ifQ.ronm156RIlJvC1S57ZRLQppmiMv5Rf-GCF1Vdq6T93U",
  "expiry" : "300"
}
```

Note: Both access_token and refresh_token must be passed to the SDK during initialization.

## 📲 Requirements
- iOS 13.0+
- Swift 6+
- Xcode 15+

## 🛠️ Permissions
The app’s Info.plist must contain the NSCameraUsageDescription key with a string value explaining to the user how the app uses this data. Example: “This will allow <your-app-name> to scan QR Code."

## 🔧 Steps to Add a Framework:

```swift
1. Open Your Xcode Project
   - Open your project in Xcode.

2. Add the Swift Package
   - From the top menu, go to File → Add Packages…
   - In the search bar, paste the TerraPay SDK repository URL:
      https://github.com/sdk-terrapay/paybywallet-ios.git
   - Select the appropriate version / branch / commit as shared.
   - Click Add Package.

3. Select the Target
   - When prompted, select your application target where the SDK should be added.
   - Click Add Package to complete the setup.

4. Verify Framework Linking
   - Select your project in the Project Navigator.
   - Go to General → Frameworks, Libraries, and Embedded Content.
   - Ensure TerraPaySDK appears in the list.
   - Confirm the embedding option is set to Embed & Sign (if required).

5. Verify Build Settings
   - Go to the Build Settings tab.
   - Ensure no manual Framework Search Paths are required (SPM manages this automatically).

6. Import the SDK in Code
   - Use the following import statement based on your project: 
    import TerrapayWalletSDK

    You can now access the SDK APIs in Swift, SwiftUI, or Objective-C.
```


## 🛠️ Usage

```swift
## config params validation as below
- accessToken               (Required) OAuth2 access token generated from partner backend.
- refreshToken              (Required) OAuth2 refresh token generated from partner backend.
- subscriberDialCode        (Required) Must match the pattern ^\+\d+$
- subscriberCountry         (Required) Must be a valid ISO 3166-1 alpha-2 country code.
- subscriberCountryName     (Required) Must be a valid ountry name.
- subscriberName            (Required) Must not be empty.
- subscriberMSISDN          (Required) Must contain only digits; length validated against country-specific rules.
- subscriberCurrency        (Required) Must be a valid ISO 4217 currency code.
- walletBalance             (Required) Must not be empty.
- primaryColor              (Required) Must be a valid 6-digit hex code (e.g., EC1B24).
- secondaryColor            (Required) Must be a valid 6-digit hex code (e.g., FFFFFF).
```

### Swift

#### 1. Import the SDK

```swift
import TerrapayWalletSDK
```

#### 2. Initialize and Launch the SDK

```swift
let config = TerrapaySDKConfig(controller: self,
                                       accessToken: "YOUR_ACCESS_TOKEN",
                                       refreshToken: "YOUR_REFRESH_TOKEN",
                                       subscriberDialCode: "+254",
                                       subscriberCountry: "KE",
                                       subscriberCountryName: "KENYA",
                                       subscriberName: "Giri Babu",
                                       subscriberMSISDN: "792467464",
                                       subscriberCurrency: "KES",
                                       walletBalance: "10000",
                                       primaryColor: "52B44A",
                                       secondaryColor: "FFFFFF")
        
TerraPayClient.shared.launch(with: config) { result, error in
    switch result {
    case .onPINAuthenticate: print("PIN Authentication UI")
    case .onError: print("Error: \(error?.message ?? "")")
    case .cancelled: print("User cancelled")
    case .onPaymentSuccess: print("Payment success")
    case .onPaymentFailure: print("Payment failed")
    @unknown default: fatalError()
    }
}
```

#### 3. Process Payment after PIN verified

Use below code to process the payment after PIN authentication successful.

```swift
TerraPayWalletClient.shared.processPayment(controller: self, transactionId: "TP123456789") // transactionId is unique identifier
```

### Objective-C

#### 1. Import the SDK

```objc
#import "TerraPayWalletSDK/TerraPayWalletSDK-Swift.h"
```

#### 2. Initialize and Launch the SDK

```objc
 TerraPayWalletSDKConfig *config =
        [[TerraPayWalletSDKConfig alloc] initWithController:self
                                            accessToken:@"YOUR_ACCESS_TOKEN",
                                            refreshToken:@"YOUR_REFRESH_TOKEN",
                                          subscriberDialCode:@"+256"
                                          subscriberCountry:@"UG"
                                     subscriberCountryName:@"UGANDA"
                                            subscriberName:@"MTN MoMo"
                                         subscriberMSISDN:@"766901491"
                                       subscriberCurrency:@"UGX"
                                            walletBalance:@"100000"
                                             primaryColor:@"52B44A"
                                           secondaryColor:@"FFFFFF"];
    
    [[TerraPayWalletClient shared] launchWith: config
                            completionHandler:^(TPLaunchType launchType,
                                                TPErrorInfo * _Nullable error,
                                                TPMerchant * _Nullable merchantmodel,
                                                TPPaymentStatus * _Nullable statusModel) {
        
        switch (launchType) {
            case TPLaunchTypeOnPINAuthenticate: {
               
                break;
            }

            case TPLaunchTypeOnError: {
                if (error.message != nil) {
                    [self showToastWithMessage:error.message];
                }
                break;
            }

            case TPLaunchTypeCancelled: {
                [self showToastWithMessage:@"User cancelled."];
                break;
            }

            case TPLaunchTypeOnPaymentSuccess: {
                NSLog(@"Base app: %@", statusModel.description);
                break;
            }

            case TPLaunchTypeOnPaymentFailure: {
                if (error != nil) {
                    [self showToastWithMessage:error.message];
                } else {
                    [self showToastWithMessage:@"Something went wrong."];
                }
                break;
            }
        }
    }];
```

#### 3. Process Payment after PIN verified

```objc
 [[TerraPayWalletClient shared] processPaymentWithController:self transactionId: "TP123456789"];
```

### SwiftUI

#### 1. Import the SDK

```SwiftUI
import TerraPaySDK
```

#### 2. Initialize and Launch the SDK

```SwiftUI
 guard let rootVC = UIApplication.shared.windows.first?.rootViewController else { return }
        let config = TerraPayWalletSDKConfig(controller: rootVC,
                                             accessToken: "YOUR_ACCESS_TOKEN",
                                             refreshToken: "YOUR_REFRESH_TOKEN",
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
                merchantData = merchantDetails
                //Navigate to PIN Screen
                break
            case .onError:
                print("Error")
            case .cancelled:
                print("User cancelled")
            case .onPaymentSuccess:
                print("Base app: \(status?.description)")
            case .onPaymentFailure:
                guard let error = error else{
                    print("Something went wrong.")
                    return
                }
                print("Something went wrong.")
            default:
                print("Something went wrong.")
            }
        }
```
#### 3. Process Payment after PIN verified

```SwiftUI
TerraPayWalletClient.shared.processPayment(controller: rootVC, transactionId: "TP123456789")
```

## 📁 Project Structure

```
Consumer Demo/
├── Samples/
│   └── Objective-C/
│   └── Swift/
│   └── SwiftUI/
├── Sources/
│   └── TerraPayWalletSDK.xcframework
├── Package.swift
└── README.md
```


## 🔐 License

This SDK is proprietary and intended for internal or authorized use only. For licensing, please contact TerraPay.

## 📬 Contact

For support or inquiries, email: sdk-support@terrapay.com

