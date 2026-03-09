//
//  UIFont+Extensions.swift
//  ConsumerApp
//
//  Created by Sunku Sneha on 18/09/25.
//

import Foundation
import UIKit

extension UIFont {
    
    // load framework font in application
    static func loadRobotoFonts() {
        if nil == UIFont(name: "Roboto-Regular", size: 1) {
            registerFontWith(filenameString: "Roboto-Regular.ttf")
            registerFontWith(filenameString: "Roboto-Medium.ttf")
            registerFontWith(filenameString: "Roboto-Bold.ttf")
            registerFontWith(filenameString: "Roboto-Light.ttf")
            registerFontWith(filenameString: "Roboto-Thin.ttf")
        }
    }
    
    static func registerFontWith(filenameString: String) {
        guard let pathForResourceString = Bundle.main.path(forResource: filenameString, ofType: nil) else {
            print("UIFont+:  Failed to register font - path for resource not found.")
            return
        }
        
        guard let fontData = NSData(contentsOfFile: pathForResourceString) else {
            print("UIFont+:  Failed to register font - font data could not be loaded.")
            return
        }
        
        guard let dataProvider = CGDataProvider(data: fontData) else {
            print("UIFont+:  Failed to register font - data provider could not be loaded.")
            return
        }
        
        guard let font = CGFont(dataProvider) else {
            print("UIFont+:  Failed to register font - font could not be loaded.")
            return
        }
        
        var errorRef: Unmanaged<CFError>? = nil
        if (CTFontManagerRegisterGraphicsFont(font, &errorRef) == false) {
            print("UIFont+:  Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
        }
        
    }
    
    func withWeight(_ weight: UIFont.Weight) -> UIFont {
        let newDescriptor = fontDescriptor.addingAttributes([.traits: [
            UIFontDescriptor.TraitKey.weight: weight]
                                                            ])
        return UIFont(descriptor: newDescriptor, size: pointSize)
    }
    
    enum Font: Equatable {
        case regular
        case medium
        case semibold
        case bold
        case light
        case thin
        case custom(String)
        
        var value: String {
            switch self {
            case .regular:
                return "Roboto-Regular"
            case .medium:
                return "Roboto-Medium"
            case .semibold:
                return "Roboto-Medium"
            case .bold:
                return "Roboto-Bold"
            case .light:
                return "Roboto-Light"
            case .thin:
                return "Roboto-Thin"
            case .custom(let name):
                return name
            }
        }
    }
    
    static func custom(_ type: Font, size: CGFloat = 18) -> UIFont {
        guard let font = UIFont.init(name: type.value, size: size) else { return UIFont() }
        if type == Font.semibold {
            return font.withWeight(.semibold)
        }
        return font
    }
}

