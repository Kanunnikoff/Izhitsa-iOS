//
//  Core.swift
//  izhitsa
//
//  Created by Дмитрiй Канунниковъ on 05.08.2019.
//  Copyright © 2019 Dmitry Kanunnikoff. All rights reserved.
//

import Foundation

struct Core {
    static let APPSTORE_YAT_URL = "https://itunes.apple.com/app/id1459031067"
    static let APPSTORE_APP_URL = "https://itunes.apple.com/app/id1475542308"
    static let APPSTORE_APP_REVIEW_URL = "https://itunes.apple.com/app/id1475542308?action=write-review"
    static let APPSTORE_DEVELOPER_URL = "https://itunes.apple.com/developer/id1449411291"
    static let PRIVACY_POLICY_URL = "https://docs.google.com/document/d/189iftSQQuRh8VGhFnCUDY5ujwgU5gsnnPIUjOGL5ypE/edit?usp=sharing"
    
    static let IS_PREMIUM_PURCHASED = "is_premium_purchased"
    static let PREMIUM_SKU_ID = "software.kanunnikoff.izhitsa.premium"
    
    static let PACKAGE_NAME = "software.kanunnikoff.izhitsa"
    
    static func isPremiumPurchased() -> Bool {
        return UserDefaults.standard.bool(forKey: Core.IS_PREMIUM_PURCHASED)
    }
    
    static func setPremiumPurchased(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: Core.IS_PREMIUM_PURCHASED)
    }
}
