//
//  TPPINView.swift
//  ConsumerApp
//
//  Created by Sunku Sneha on 09/03/26.
//
//
import SwiftUI
import TerraPayWalletSDK

struct PINEntryView: View {
    @State private var pin: String = ""
    private let maxDigits = 4
    @Environment(\.dismiss) var dismiss
    var onCompletion: () -> Void
    // Custom number pad layout
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack(alignment: .top) {
            // 1. Teal Background Header
            Color(red: 0.0, green: 0.38, blue: 0.5)
                .frame(height: 250)
//                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 2. Transaction Info Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("To : State Oil DSM")
                                .font(.subheadline.bold())
                            Text("Sending : KES 2078.01")
                                .font(.subheadline)
                        }
                        Spacer()
                        Text("Verify OTP")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color(white: 0.95))
                .cornerRadius(12, corners: [.topLeft, .topRight])
                .padding(.horizontal)
                .padding(.top, 60)
                
                // 3. Main PIN Entry White Card
                VStack(spacing: 30) {
                    Text("Enter 4 Digit PIN")
                        .font(.headline)
                        .padding(.top, 40)
                    
                    // PIN Indicators
                    HStack(spacing: 25) {
                        ForEach(0..<maxDigits, id: \.self) { index in
                            ZStack {
                                // The Underline or Box
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(index < pin.count ? Color.blue : Color.gray.opacity(0.3), lineWidth: 1)
                                    .frame(width: 45, height: 50)
                                    .background(Color.placeholdercolor)
                                
                                // The Number (if entered)
                                if index < pin.count {
                                    let charIndex = pin.index(pin.startIndex, offsetBy: index)
                                    Text(String(pin[charIndex]))
                                        .font(.title3.weight(.semibold))
                                        .foregroundColor(.primarycolor)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 60)
                }
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .padding(.horizontal)
                
                // 4. Custom Number Pad
                VStack {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(1...9, id: \.self) { num in
                            NumberButton(number: "\(num)", action: { addDigit("\(num)") })
                        }
                        
                        // Bottom row
                        Spacer()
                        NumberButton(number: "0", action: { addDigit("0") })
                        
                        Button(action: deleteDigit) {
                            Image(systemName: "delete.left")
                                .font(.title)
                                .foregroundColor(.blue)
                        }
                        .frame(height: 60)
                    }
                    .padding(30)
                }
                .background(Color(white: 0.92))
                
                // Footer
                Text("Powered by")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.vertical)
            }
        }.background(Color(white: 0.92).ignoresSafeArea())
    }
        
    
    func submitPin() {
        // Find the current UIViewController to satisfy the SDK requirement
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else { return }
        
        // 1. Trigger the actual payment process
        TerraPayWalletClient.shared.processPayment(
            controller: rootVC,
            transactionId: "TXN-\(Int.random(in: 100000...999999))"
        )
        
        // 2. Dismiss the custom PIN screen
        dismiss()
    }
    
    // Logic functions
    func addDigit(_ digit: String) {
        if pin.count < maxDigits {
            pin.append(digit)
            if pin.count == maxDigits {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    submitPin()
                }
            }
        }
    }
    
    func deleteDigit() {
        if !pin.isEmpty {
            pin.removeLast()
        }
    }
}

// Reusable Number Button Component
struct NumberButton: View {
    let number: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(number)
                .font(.title2.bold())
                .foregroundColor(Color(red: 0.0, green: 0.3, blue: 0.6))
                .frame(maxWidth: .infinity)
                .frame(height: 60)
        }
    }
}

// Extension for selective corner radius
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
