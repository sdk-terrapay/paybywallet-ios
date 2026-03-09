//
//  TPNetworkManager.swift
//  ConsumerApp
//
//  Created by Sunku Sneha on 05/03/26.
//

import UIKit
import Foundation
import Network

enum TPNetworkStatus {
    case satisfied
    case unsatisfied
    case requiresConnection
}

struct TPNetworkManager {
    
    // MARK: - Singleton
    static let shared = TPNetworkManager()
    static var networkStatus: TPNetworkStatus = .unsatisfied
    
    func initialize() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                TPNetworkManager.networkStatus = .satisfied
            } else if path.status == .unsatisfied {
                TPNetworkManager.networkStatus = .unsatisfied
            } else {
                TPNetworkManager.networkStatus = .requiresConnection
            }
        }
        
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
    func showNoInternetAlert(with parent: UIViewController?) {
//        let alertController = UIAlertController(title: "No Internet", message: "Please check your internet connection and try again!", preferredStyle: .alert)
//        let alertAction = UIAlertAction(title: "Okay", style: .cancel) { _ in
//        }
//        alertController.addAction(alertAction)
//        parent?.present(alertController, animated: true)
        
//        let snackbar = TPSnackbar(message: "Please check your internet connection and try again!")
//        snackbar.show(in: parent!.view)
    }
}

