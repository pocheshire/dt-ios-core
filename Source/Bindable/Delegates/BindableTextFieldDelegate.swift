//
//  BindableTextFieldDelegate.swift
//
//  Copyright © 2019 DreamTeamMobile. All rights reserved.
//

import UIKit

open class BindableTextFieldDelegate : NSObject, UITextFieldDelegate {
    
    // MARK: Fields
    
    public let inputFrame: InputFrame
    
    public let textField: UITextField
    
    // MARK: Properties
    
    public var onReturnExecute: (() -> Void)?
    
    // MARK: Init
    
    public init(inputFrame: InputFrame, textField: UITextField) {
        self.inputFrame = inputFrame
        self.textField = textField
        super.init()
        setupBindings()
    }
    
    // MARK: Private methods
    
    private func setupBindings() {
        self.textField.text = self.inputFrame.text
        self.textField.addTarget(self, action: #selector(onTextFieldValueChanged), for: .editingChanged)
        self.textField.addTarget(self, action: #selector(onTextFieldValueChanged), for: .editingDidEnd)
        self.inputFrame.$text.bindAndFire(self.onTextChanged)
    }
    
    @objc private func onTextFieldValueChanged(_ sender: UITextField) {
        self.inputFrame.text = sender.text ?? ""
    }
    
    private func onTextChanged(_ oldValue: String, _ newValue: String) {
        if newValue != self.textField.text {
            self.textField.text = newValue
        }
    }
    
    // MARK: UITextFieldDelegate implementation
    
    /// return NO to disallow editing.
    open func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }

    /// became first responder
    open func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }

    /// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
    open func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }

    /// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
    open func textFieldDidEndEditing(_ textField: UITextField) {
        
    }

    /// if implemented, called in place of textFieldDidEndEditing:
    @available(iOS 10.0, *)
    open func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
    }
    
    /// return NO to not change text
    open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString text: String) -> Bool {
        return self.inputFrame.shouldChangeCharactersIn(range: range, replacementString: text)
    }
    
    @available(iOS 13.0, *)
    open func textFieldDidChangeSelection(_ textField: UITextField) {
        
    }
    
    /// called when clear button pressed. return NO to ignore (no notifications)
    open func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }

    /// called when 'return' key pressed. return NO to ignore.
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        self.onReturnExecute?()
        return true
    }
    
}
