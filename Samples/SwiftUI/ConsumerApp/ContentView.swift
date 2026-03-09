//
//  ContentView.swift
//  ConsumerApp
//
//  Created by Sunku Sneha on 06/03/26.
//

import SwiftUI
import TerraPayWalletSDK
import Combine

struct ContentView: View {
    @State private var showPinEntry = false
    @State var subscriberName = "TerraPay User"
    @State var msisdn = "766901491"
    @State var dialCode = "+256"
    @State var balance = "100000"
    @State var currencyCode = "KES"
    @State var countryCode = "KE"
    @State var countryName = "KENYA"
    @State var merchantData: TPMerchantModel?
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                // 1. Background Header
                Color(red: 0.0, green: 0.4, blue: 0.5) // Deep Teal
                    .frame(height: 250)
                    .ignoresSafeArea()
                
                VStack(spacing: 60) {
                    // 2. User Profile Section
                    HStack(spacing: 15) {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 60, height: 60)
                            .overlay(Text("TU").bold().foregroundColor(.teal))
                        
                        VStack(alignment: .leading) {
                            Text("TerraPay User")
                                .font(.title3.bold())
                            Text("+256766901491")
                                .font(.subheadline)
                        }
                        .foregroundColor(.white)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)

                    // 3. Wallet Balance Card
                    VStack(spacing: 8) {
                        Text("Wallet Balance")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Text("KES 100000")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 30)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                    .padding(.horizontal)
                   
                    // 4. Action Button Card
                    VStack {
                        Button(action: {
                            launchSDK()
                                }) {
                                    Text("International Merchant Payments")
                                        // ... styling ...
                                }                    }
                    .padding()
                    .background(Color.primarycolor)
                    .foregroundColor(Color.buttonFG)
                    .cornerRadius(15)
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .background(Color(white: 0.97))
            .fullScreenCover(isPresented: $showPinEntry) {
                PINEntryView {
                    showPinEntry = false
                }
            }
        }
    }
    func launchSDK() {
        guard let rootVC = UIApplication.shared.windows.first?.rootViewController else { return }
        let config = TerraPayWalletSDKConfig(controller: rootVC,
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
                showPinEntry = true
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
    }
}
