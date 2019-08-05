//
//  Util.swift
//  izhitsa
//
//  Created by Дмитрiй Канунниковъ on 05.08.2019.
//  Copyright © 2019 Dmitry Kanunnikoff. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents.MaterialSnackbar

struct Util {
    
    static func showAlert(context: UIViewController, title: String?, message: String?, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Добро", style: .default, handler: handler))
        alert.popoverPresentationController?.sourceView = context.view // so that iPads won't crash
        context.present(alert, animated: true)
    }
    
    static func showPremiumAlert(context: UIViewController, title: String?, message: String?, buyHandler: ((UIAlertAction) -> Void)?, restoreHandler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Купить", style: .destructive, handler: buyHandler))
        alert.addAction(UIAlertAction(title: "Возстановить", style: .default, handler: restoreHandler))
        alert.addAction(UIAlertAction(title: "Отмѣна", style: .default, handler: nil))
        alert.popoverPresentationController?.sourceView = context.view // so that iPads won't crash
        context.present(alert, animated: true)
    }
    
    static func snackbar(_ text: String) {
        let message = MDCSnackbarMessage()
        message.text = text
        MDCSnackbarManager.show(message)
    }
    
    static func share(url: String, withContext context: UIViewController) {
        let textToShare = [ url ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = context.view // so that iPads won't crash
        
        context.present(activityViewController, animated: true, completion: nil)
    }
    
    static func browse(url: String) {
        if let url = URL(string: url), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
