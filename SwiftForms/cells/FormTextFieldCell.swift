//
//  FormTextFieldCell.swift
//  SwiftForms
//
//  Created by Miguel Ángel Ortuño Ortuño on 20/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import UIKit

open class FormTextFieldCell: FormBaseCell {
    
    // MARK: Cell views
    
    @objc open let titleLabel = UILabel()
    @objc open let textField  = UITextField()
    // ADDED - Romain VINCENS - 20/02/2017 - MAIF-884
    open let subtitleLabel = UILabel()
    // END ADDED
    
    // MARK: Properties
    
    fileprivate var customConstraints: [AnyObject] = []
    
    // MARK: FormBaseCell
    
    open override func configure() {
        super.configure()
        
        selectionStyle = .none
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        // ADDED - Romain VINCENS - 20/02/2017 - MAIF-884
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        // END ADDED

        
        titleLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        textField.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        // ADDED - Romain VINCENS - 20/02/2017 - MAIF-884
        subtitleLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.callout)
        // END ADDED
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(textField)
        // ADDED - Romain VINCENS - 20/02/2017 - MAIF-884
        contentView.addSubview(subtitleLabel)
        // END ADDED
        
        // REPLACED - Romain VINCENS - 20/02/2017 - MAIF-884 + MAIF-980
//        titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 500), for: .horizontal)
//        titleLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        // WITH
        titleLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh+1, for: .horizontal)
        // END REPLACED
        
        // REPLACED - Romain VINCENS - 20/02/2017 - MAIF-884
        //        contentView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: contentView, attribute: .height, multiplier: 1.0, constant: 0.0))
        //        contentView.addConstraint(NSLayoutConstraint(item: textField, attribute: .height, relatedBy: .equal, toItem: contentView, attribute: .height, multiplier: 1.0, constant: 0.0))
        //        contentView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        //        contentView.addConstraint(NSLayoutConstraint(item: textField, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        // WITH
        let labelContainerGuide = UILayoutGuide()
        addLayoutGuide(labelContainerGuide)
        
        titleLabel.topAnchor.constraint(equalTo: labelContainerGuide.topAnchor).isActive = true
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        subtitleLabel.bottomAnchor.constraint(equalTo: labelContainerGuide.bottomAnchor).isActive = true
        labelContainerGuide.topAnchor.constraint(greaterThanOrEqualTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        labelContainerGuide.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        textField.firstBaselineAnchor.constraint(equalTo: titleLabel.firstBaselineAnchor).isActive = true
        // END REPLACED
        
        textField.addTarget(self, action: #selector(FormTextFieldCell.editingChanged(_:)), for: .editingChanged)
    }
    
    open override func update() {
        super.update()
        
        if let showsInputToolbar = rowDescriptor?.configuration.cell.showsInputToolbar , showsInputToolbar && textField.inputAccessoryView == nil {
            textField.inputAccessoryView = inputAccesoryView()
        }
        
        titleLabel.text = rowDescriptor?.title
        // ADDED - Romain VINCENS - 20/02/2017 - MAIF-884
        subtitleLabel.text = rowDescriptor?.subtitle
        // END ADDED
        textField.text = rowDescriptor?.value as? String
        textField.placeholder = rowDescriptor?.configuration.cell.placeholder
        
        textField.isSecureTextEntry = false
        textField.clearButtonMode = .whileEditing
        
        if let type = rowDescriptor?.type {
            switch type {
            case .text:
                textField.autocorrectionType = .default
                textField.autocapitalizationType = .sentences
                textField.keyboardType = .default
            case .number:
                textField.keyboardType = .numberPad
            case .numbersAndPunctuation:
                textField.keyboardType = .numbersAndPunctuation
            case .decimal:
                textField.keyboardType = .decimalPad
            case .name:
                textField.autocorrectionType = .no
                textField.autocapitalizationType = .words
                textField.keyboardType = .default
            case .phone:
                textField.keyboardType = .phonePad
            case .namePhone:
                textField.autocorrectionType = .no
                textField.autocapitalizationType = .words
                textField.keyboardType = .namePhonePad
            case .url:
                textField.autocorrectionType = .no
                textField.autocapitalizationType = .none
                textField.keyboardType = .URL
            case .twitter:
                textField.autocorrectionType = .no
                textField.autocapitalizationType = .none
                textField.keyboardType = .twitter
            case .email:
                textField.autocorrectionType = .no
                textField.autocapitalizationType = .none
                textField.keyboardType = .emailAddress
            case .asciiCapable:
                textField.autocorrectionType = .no
                textField.autocapitalizationType = .none
                textField.keyboardType = .asciiCapable
            case .password:
                textField.isSecureTextEntry = true
                textField.clearsOnBeginEditing = false
            default:
                break
        }
        }
    }
    
    open override func constraintsViews() -> [String : UIView] {
        // REPLACED - Romain VINCENS - 20/02/2017 - MAIF-884
        //        var views = ["titleLabel" : titleLabel, "textField" : textField]
        // WITH
        var views = ["titleLabel" : titleLabel, "textField" : textField, "subtitleLabel": subtitleLabel]
        // END REPLACED
        if self.imageView!.image != nil {
            views["imageView"] = imageView
        }
        return views
    }
    
    open override func defaultVisualConstraints() -> [String] {
        // REPLACED - Bastien PENALBA - 19/09/16
        //        if self.imageView!.image != nil {
        //            if titleLabel.text != nil && (titleLabel.text!).characters.count > 0 {
        //                return ["H:[imageView]-[titleLabel]-[textField]-16-|"]
        //            } else {
        //                return ["H:[imageView]-[textField]-16-|"]
        //            }
        //        } else {
        //            if titleLabel.text != nil && (titleLabel.text!).characters.count > 0 {
        //                return ["H:|-16-[titleLabel]-[textField]-16-|"]
        //            } else {
        //                return ["H:|-16-[textField]-16-|"]
        //            }
        //        }
        // WITH
        if self.imageView!.image != nil {
            if titleLabel.text != nil && (titleLabel.text!).characters.count > 0 {
                return ["H:[imageView]-[titleLabel]-[textField]-|", "H:[imageView]-[subtitleLabel]-|"]
            } else {
                return ["H:[imageView]-[textField]-|", "H:[imageView]-[subtitleLabel]-|"]
            }
        } else {
            if titleLabel.text != nil && (titleLabel.text!).characters.count > 0 {
                return ["H:|-[titleLabel]-[textField]-|", "H:|-[subtitleLabel]-|"]
            } else {
                return ["H:|-[textField]-|", "H:|-[subtitleLabel]-|"]
            }
        }
        // END REPLACED
    }
    
    open override func firstResponderElement() -> UIResponder? {
        return textField
    }
    
    open override class func formRowCanBecomeFirstResponder() -> Bool {
        return true
    }
    
    // MARK: Actions
    
    // REPLACED - Morgan LE GAL - 28/09/2017
    //@objc internal func editingChanged(_ sender: UITextField) {
    // WITH
    @objc open func editingChanged(_ sender: UITextField) {
    // END REPLACED
        guard let text = sender.text, text.characters.count > 0 else { rowDescriptor?.value = nil; update(); return }
        rowDescriptor?.value = text as AnyObject
    }
}
