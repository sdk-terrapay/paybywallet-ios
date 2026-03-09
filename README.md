## 📦 TerraPaySDK

This SDK, provided by TerraPay, enables seamless payment transactions between customers and merchants through the partner mobile application. It supports multiple payment methods, including QR code scanning and merchant ID–based payments, and is designed for easy integration with iOS platform.

## 🚀 Features

- QR Code and Merchant ID Payments.
- Customizable User Experience with brand colors.
- Launch SDK with a single entry point.
- Easily embeddable into any iOS app.

## 📲 Requirements
- iOS 13.0+
- Swift 6+
- Xcode 15+

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
    import TerraPaySDK

    You can now access the SDK APIs in Swift, SwiftUI, or Objective-C.
```


## 🛠️ Usage

```swift
## config params validation as below
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
import TerraPaySDK
```

#### 2. Initialize and Launch the SDK

```swift
let config = TerrapaySDKConfig(controller: self,
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
TerraPayWalletClient.shared.processPayment(controller: self, transactionId: "TP123456789")
```

### Objective-C

#### 1. Import the SDK

```objc
#import "TerraPaySDK/TerraPaySDK-Swift.h"
```

#### 2. Initialize and Launch the SDK

```objc
TerrapaySDKConfig *config = [[TerrapaySDKConfig alloc] initWithController:self
                                                                  accessToken:@"YOUR_ACCESS_TOKEN",
                                                                 refreshToken:@"YOUR_REFRESH_TOKEN",
                                                                     dialCode:@"+254"
                                                                       msisdn:@"123456789"
                                                               subscriberName:@"Giri Babu"
                                                                   walletName:@"Airtel Money Wallet"
                                                                     currency:@"KES"
                                                                  countryCode:@"KE"
                                                                 primaryColor:@"EC1B24"
                                                               secondaryColor:@"FFFFFF"
                                                                        email:@"test@test.com"
                                                                   topUpLabel:@"Top Up"
                                                                withdrawLabel:@"Withdraw"
                                                           termsConditionsUrl:@""];
    
    
[[TerraPayClient shared] launchWith:config completionHandler:^(TerraPayResultType result, TerraPayErrorInfo *error) {
    switch (result) {
        case TerraPayResultTypeSuccess:
            NSLog(@"SDK launched successfully");
            break;
        case TerraPayResultTypeCancelled:
            NSLog(@"User cancelled");
            break;
        case TerraPayResultTypeFailure:
            NSLog(@"Error Code: %@", error.code);
            NSLog(@"Error Message: %@", error.message);
            break;
    }
}];
```

#### 3. Configure url scheme

URL Shemes needs to be configured as "tpwallet" under URL Types. 

// Add below code in AppDelegate.m file

```objc
#import "TerraPaySDK/TerraPaySDK-Swift.h"

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    
    [[TerraPayClient shared] handleRedirectWithUrl:url];
    return YES;
}
```

### SwiftUI

#### 1. Import the SDK

```SwiftUI
import TerraPaySDK
```

#### 2. Initialize and Launch the SDK

```SwiftUI
let config = TerrapaySDKConfig(controller: viewcontroller,
                                accessToken: "YOUR_ACCESS_TOKEN",
                                refreshToken: "YOUR_REFRESH_TOKEN",
                                dialCode: "+254",
                                msisdn: "123456789",
                                subscriberName: "Giri Babu",
                                walletName: "Airtel Money Wallet",
                                currency: "KES",
                                countryCode: "KE",
                                primaryColor: "EC1B24",
                                secondaryColor: "FFFFFF",
                                email: "test@test.com",
                                topUpLabel: "Top-Up",
                                withdrawLabel: "Withdraw",
                                termsConditionsUrl: "")

TerraPayClient.shared.launch(with: config) { result, error in
    switch result {
    case .success: print("SDK launched successfully")
    case .cancelled: print("User cancelled")
    case .failure: print("Error: \(error?.message ?? "")")
    @unknown default: fatalError()
    }
}
```
#### 3. Configure url scheme

URL Shemes needs to be configured as "tpwallet" under URL Types. 

// Add below code in View file

```SwiftUI
    struct ContentView: View {
        var body: some View {
            Text("Hello, SwiftUI!")
                .onOpenURL { url in
                    TerraPayClient.shared.handleRedirect(url: url)
                }
        }
    }
```



## 📁 Project Structure

```
TerraPaySDK/
├── Sample/
│   └── Objective-C/
│   └── Swift/
│   └── SwiftUI/
├── Sources/
│   └── TerraPaySDK.xcframework
├── Package.swift
└── README.md
```


## 🔐 License

This SDK is proprietary and intended for internal or authorized use only. For licensing, please contact TerraPay.

## 📬 Contact

For support or inquiries, email: sdk-support@terrapay.com

