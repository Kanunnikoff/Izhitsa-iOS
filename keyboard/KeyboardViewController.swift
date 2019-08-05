//
//  KeyboardViewController.swift
//  keyboard
//
//  Created by Дмитрiй Канунниковъ on 19.07.2019.
//  Copyright © 2019 Dmitry Kanunnikoff. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {
    private var capsLockOn = false
    
    @IBOutlet var nextKeyboardButton: UIButton!
    @IBOutlet weak var backspaceButton: UIButton!
    
    var keyboardView: UIView!
    var timer: Timer? = nil
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadInterface()

        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
        self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }
    
    func loadInterface(){
        let keyboardNib = UINib(nibName: "KeyboardView", bundle: nil)
        keyboardView = keyboardNib.instantiate(withOwner: self, options: nil)[0] as! UIView
        keyboardView.frame.size = view.frame.size
        view.addSubview(keyboardView)
    }
    
    @IBAction func backspacePressed(_ sender: UIButton) {
        (textDocumentProxy as UIKeyInput).deleteBackward()
    }
    
    @IBAction func spacePressed(_ sender: UIButton) {
        (textDocumentProxy as UIKeyInput).insertText(" ")
    }
    
    @IBAction func returnPressed(_ sender: UIButton) {
        (textDocumentProxy as UIKeyInput).insertText("\n")
    }
    
    @IBAction func capslockPressed(_ sender: UIButton) {
        capsLockOn = !capsLockOn
        changeCaps(containerView: keyboardView)
    }
    
    @IBAction func keyPressed(_ sender: UIButton) {
        let string = sender.titleLabel!.text
        (textDocumentProxy as UIKeyInput).insertText("\(string!)")
    }
    
    func changeCaps(containerView: UIView) {
        for view in containerView.subviews {
            if let button = view as? UIButton {
                let buttonTitle = button.titleLabel!.text
                
                if buttonTitle == "CL" {
                    if capsLockOn {
                        button.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
                    } else {
                        button.backgroundColor = UIColor(red: 167/255, green: 175/255, blue: 186/255, alpha: 1.0)
                    }
                }
                
                if buttonTitle == nil || buttonTitle?.isEmpty == true || buttonTitle == "Вводъ" || buttonTitle == "Пробѣлъ" || buttonTitle == "CL" || buttonTitle == "BS" {
                    continue
                }
                
                if capsLockOn {
                    let text: String = buttonTitle!.uppercased()
                    button.setTitle("\(text)", for: .normal)
                } else {
                    let text = buttonTitle!.lowercased()
                    button.setTitle("\(text)", for: .normal)
                }
            }
        }
    }
    
    /* Выставляем высоту клавиатуры. */
    override func viewWillAppear(_ animated: Bool) {
        let desiredHeight: CGFloat!
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            desiredHeight = 200
        } else {
            if UIDevice.current.orientation == .portrait {
                desiredHeight = 260
            } else {
                desiredHeight = 300
            }
        }
        
        let heightConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: desiredHeight)
        view.addConstraint(heightConstraint)
    }
    
    
    
}
