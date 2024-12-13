//
//  AlertClass.swift
//  stayConect
//
//  Created by Nkhorbaladze on 06.12.24.
//

import UIKit

final class AlertClass {
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController {
            rootViewController.present(alertController, animated: true, completion: nil)
        }
    }
}
