//
//  KeyboardButton.swift
//  izhitsa
//
//  Created by Дмитрiй Канунниковъ on 04.08.2019.
//  Copyright © 2019 Dmitry Kanunnikoff. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class KeyboardButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 5 {
        didSet {
            refreshCorners(value: cornerRadius)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    func sharedInit() {
        refreshCorners(value: cornerRadius)
        tintColor = .black
    }
    
    func refreshCorners(value: CGFloat) {
        layer.cornerRadius = value
    }
}
