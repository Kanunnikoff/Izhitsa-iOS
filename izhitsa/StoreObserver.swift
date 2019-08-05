//
//  StoreObserver.swift
//  izhitsa
//
//  Created by Дмитрiй Канунниковъ on 05.08.2019.
//  Copyright © 2019 Dmitry Kanunnikoff. All rights reserved.
//

import Foundation
import StoreKit

enum StoreObserverStatus {
    case disabled
    case failed
    case restored
    case purchased
    
    func message() -> String{
        switch self {
        case .disabled: return "Purchases are disabled in your device!"
        case .failed: return "Failed to purchase!"
        case .restored: return "You've successfully restored your purchase!"
        case .purchased: return "You've successfully bought this purchase!"
        }
    }
}

class StoreObserver: NSObject {
    private static var instance: StoreObserver?
    
    //    private var productID = ""
    private var productsRequest = SKProductsRequest()
    private var iapProducts = [SKProduct]()
    
    var purchaseStatusBlock: ((StoreObserverStatus) -> Void)?
    
    // MARK: - MAKE PURCHASE OF A PRODUCT
    func canMakePurchases() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    func purchaseMyProduct(index: Int){
        if iapProducts.count == 0 { return }
        
        if self.canMakePurchases() {
            let product = iapProducts[index]
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
            
            //            print("PRODUCT TO PURCHASE: \(product.productIdentifier)")
            //            productID = product.productIdentifier
        } else {
            purchaseStatusBlock?(.disabled)
        }
    }
    
    // MARK: - RESTORE PURCHASE
    func restorePurchase() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    
    // MARK: - FETCH AVAILABLE IAP PRODUCTS
    func fetchAvailableProducts() {
        
        // Put here your IAP Products ID's
        let productIdentifiers = NSSet(objects: Core.PREMIUM_SKU_ID)
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    static func shared() -> StoreObserver {
        if instance == nil {
            instance = StoreObserver()
        }
        
        return instance!
    }
}

extension StoreObserver: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    // MARK: - REQUEST IAP PRODUCTS
    func productsRequest (_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        if (response.products.count > 0) {
            iapProducts = response.products
            
            //            for product in iapProducts {
            //                let numberFormatter = NumberFormatter()
            //                numberFormatter.formatterBehavior = .behavior10_4
            //                numberFormatter.numberStyle = .currency
            //                numberFormatter.locale = product.priceLocale
            //                let price1Str = numberFormatter.string(from: product.price)
            //                print(product.localizedDescription + ", \(price1Str!)")
            //            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        //purchaseStatusBlock?(.restored)
    }
    
    // MARK:- IAP PAYMENT QUEUE
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for tx in transactions {
            switch tx.transactionState {
            case .purchased:
                print("purchased")
                SKPaymentQueue.default().finishTransaction(tx)
                purchaseStatusBlock?(.purchased)
                break
                
            case .failed:
                print("failed")
                SKPaymentQueue.default().finishTransaction(tx)
                purchaseStatusBlock?(.failed)
                break
                
            case .restored:
                print("restored")
                SKPaymentQueue.default().finishTransaction(tx)
                purchaseStatusBlock?(.restored)
                break
                
            default:
                break
            }
        }
    }
}
