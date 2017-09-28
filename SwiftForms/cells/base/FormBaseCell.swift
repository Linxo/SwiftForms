//
//  FormBaseCell.swift
//  SwiftForms
//
//  Created by Miguel Angel Ortuno on 20/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import UIKit

open class FormBaseCell: UITableViewCell {
    
    // MARK: Properties
    
    open var rowDescriptor: FormRowDescriptor? {
        didSet {
            self.update()
        }
    }
    
    @objc open weak var formViewController: FormViewController?
    
    fileprivate var customConstraints: [NSLayoutConstraint] = []
    
    // MARK: Init
    
    public required override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Public interface
    
    @objc open func configure() {
        /// override
    }
    
    @objc open func update() {
        /// override
    }
    
    @objc open func defaultVisualConstraints() -> [String] {
        /// override
        return []
    }
    
    @objc open func constraintsViews() -> [String : UIView] {
        /// override
        return [:]
    }
    
    @objc open func firstResponderElement() -> UIResponder? {
        /// override
        return nil
    }
    
    @objc open func inputAccesoryView() -> UIToolbar {
        
        let actionBar = UIToolbar()
        actionBar.isTranslucent = true
        actionBar.sizeToFit()
        actionBar.barStyle = .default
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(FormBaseCell.handleDoneAction(_:)))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        actionBar.items = [flexible, doneButton]
        
        return actionBar
    }
    
    @objc internal func handleDoneAction(_: UIBarButtonItem) {
        firstResponderElement()?.resignFirstResponder()
    }
    
    @objc open class func formRowCellHeight() -> CGFloat {
        return 44.0
    }
    
    @objc open class func formRowCanBecomeFirstResponder() -> Bool {
        return false
    }
    
    @objc open class func formViewController(_ formViewController: FormViewController, didSelectRow: FormBaseCell) {
    }
    
    // MARK: Constraints
    
    open override func updateConstraints() {
        if customConstraints.count > 0 {
            contentView.removeConstraints(customConstraints)
        }
        
        let views = constraintsViews()
        
        customConstraints.removeAll()
        
        var visualConstraints = [String]()
        
        if let visualConstraintsClosure = rowDescriptor?.configuration.cell.visualConstraintsClosure {
            visualConstraints = visualConstraintsClosure(self)
        } else {
            visualConstraints = defaultVisualConstraints()
        }
        
        for visualConstraint in visualConstraints {
            let constraints = NSLayoutConstraint.constraints(withVisualFormat: visualConstraint, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
            for constraint in constraints {
                customConstraints.append(constraint)
            }
        }
        
        contentView.addConstraints(customConstraints)
        super.updateConstraints()
    }
}
