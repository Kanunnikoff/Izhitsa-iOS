//
//  ViewController.swift
//  izhitsa
//
//  Created by Дмитрiй Канунниковъ on 19.07.2019.
//  Copyright © 2019 Dmitry Kanunnikoff. All rights reserved.
//

import UIKit
import Crashlytics
import Firebase

class PracticeViewController: UIViewController {    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !Core.isPremiumPurchased() {
            StoreObserver.shared().fetchAvailableProducts()
            StoreObserver.shared().restorePurchase()
        }
        
        //---
        
        StoreObserver.shared().purchaseStatusBlock = { (status) in
            if status == .restored {
                Core.setPremiumPurchased(true)
                Util.showAlert(context: self, title: "Поддержка", message: "Ваша покупка успѣшно возстановлена! Спасибо!", handler: nil)
            } else if status == .purchased {
                Core.setPremiumPurchased(true)
                
                Answers.logStartCheckout(withPrice: 1, currency: "USD", itemCount: 1, customAttributes: nil)
                Answers.logPurchase(withPrice: 0.7, currency: "USD", success: true, itemName: "Premium", itemType: "In-App Purchases", itemId: Core.PREMIUM_SKU_ID, customAttributes: nil)
                
                Util.snackbar("Вашъ платёжъ полученъ. Премногая благодарность за поддержку!")
            } else if status == .disabled {
                Util.snackbar("На Вашемъ устройствѣ отключена возможность покупокъ!")
            } else if status == .failed {
                Util.snackbar("Не удалось осуществить покупку. Пожалуйста, попробуйте позже.")
            }
        }
    }

    @IBAction func menuAction(_ sender: UIButton) {
        let controller: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        controller.addAction(UIAlertAction(title: "Отмѣна", style: .cancel))
        
        controller.addAction(UIAlertAction(title: "Оцѣнить въ App Store", style: .default) { _ in
            Util.browse(url: Core.APPSTORE_APP_REVIEW_URL)
            Answers.logRating(nil, contentName: "Rating of the app in App Store.", contentType: "app", contentId: Core.PACKAGE_NAME, customAttributes: nil)
        })
        
        controller.addAction(UIAlertAction(title: "Подѣлиться", style: .default) { _ in
            Util.share(url: Core.APPSTORE_APP_URL, withContext: self)
            Answers.logShare(withMethod: nil, contentName: "Link to the app in App Store.", contentType: "link", contentId: Core.PACKAGE_NAME, customAttributes: nil)
        })
        
        controller.addAction(UIAlertAction(title: "Другiя приложенiя", style: .default) { _ in
            Util.browse(url: Core.APPSTORE_DEVELOPER_URL)
            Answers.logCustomEvent(withName: "Developer's page visited.", customAttributes: [:])
        })
        
        controller.addAction(UIAlertAction(title: "Дореволюціонный переводчикъ", style: .default) { _ in
            Util.browse(url: Core.APPSTORE_YAT_URL)
            Answers.logCustomEvent(withName: "Yat's page visited.", customAttributes: [:])
        })
        
        controller.addAction(UIAlertAction(title: "Поддержать автора", style: .default) { _ in
            if !Core.isPremiumPurchased() {
                Util.showPremiumAlert(context: self, title: "Поддержка", message: "Выберите возстановленіе, если ​Поддержка​ ранѣе уже осуществлялась.",
                                      buyHandler: { (alert) in
                                        StoreObserver.shared().purchaseMyProduct(index: 0)
                                        Answers.logAddToCart(withPrice: 1.0, currency: "USD", itemName: "Premium", itemType: "In-App Purchases", itemId: Core.PREMIUM_SKU_ID, customAttributes: nil)
                },
                                      restoreHandler: { (alert) in
                                        StoreObserver.shared().restorePurchase()
                }
                )
            } else {
                Util.snackbar("Вы уже поддержали автора. Достаточно одного раза. Сердечное спасибо!")
            }
        })
        
        controller.addAction(UIAlertAction(title: "Политика конфиденцiальности", style: .default) { _ in
            Util.browse(url: Core.PRIVACY_POLICY_URL)
            Answers.logContentView(withName: "Privacy policy.", contentType: "privacy", contentId: Core.PACKAGE_NAME, customAttributes: nil)
        })
        
        controller.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        self.present(controller, animated: true, completion: nil)
    }
    

}

