//
//  FormRowDescriptor.swift
//  SwiftForms
//
//  Created by Miguel Ángel Ortuño Ortuño on 23/08/14.
//  Copyright (c) 2016 Miguel Angel Ortuño. All rights reserved.
//

import UIKit

public final class FormRowDescriptor {
    
    // MARK: Types
    
    public enum RowType {
        case unknown
        case label
        case text
        case url
        case number
        case numbersAndPunctuation
        case decimal
        case name
        case phone
        case namePhone
        case email
        case twitter
        case asciiCapable
        case password
        case button
        case booleanSwitch
        case booleanCheck
        case segmentedControl
        case picker
        case date
        // ADDED - Morgan Le Gal - 31/10/2016 - MAIF-553
        case birthday
        // END ADDED
        case time
        case dateAndTime
        case stepper
        case slider
        case multipleSelector
        case multilineText
    }
    
    public struct CellConfiguration {
        public var cellClass:                AnyClass?
        public var appearance:               [String : AnyObject]
        public var placeholder:              String?
        public var showsInputToolbar:        Bool
        public var required:                 Bool
        public var willUpdateClosure:        ((FormRowDescriptor) -> Void)?
        public var didUpdateClosure:         ((FormRowDescriptor) -> Void)?
        // ADDED - Bastien Penalba - 23/09/16
        /// This closure is called when the user did finish editing the value instead of being called at every change
        public var didBeginEditingClosure:     ((FormRowDescriptor) -> Void)?
        public var didEndEditingClosure:     ((FormRowDescriptor) -> Void)?
        // END ADDED
        public var visualConstraintsClosure: ((FormBaseCell) -> [String])?
        
        public init() {
            cellClass = nil
            appearance = [:]
            placeholder = nil
            showsInputToolbar = false
            required = true
            willUpdateClosure = nil
            didUpdateClosure = nil
            // ADDED - Bastien Penalba - 23/09/16
            didBeginEditingClosure = nil
            didEndEditingClosure = nil
            // END ADDED
            visualConstraintsClosure = nil
        }
    }
 
    public struct SelectionConfiguration {
        public var controllerClass:         AnyClass?
        public var options:                 [AnyObject]
        public var optionTitleClosure:      ((AnyObject) -> String)?
        public var allowsMultipleSelection: Bool
        
        public init() {
            controllerClass = nil
            options = []
            optionTitleClosure = nil
            allowsMultipleSelection = false
        }
    }
    
    public struct ButtonConfiguration {
        public var didSelectClosure: ((FormRowDescriptor) -> Void)?
        
        public init() {
            didSelectClosure = nil
        }
    }
    
    public struct StepperConfiguration {
        public var maximumValue: Double
        public var minimumValue: Double
        public var steps:        Double
        public var continuous:   Bool
        
        public init() {
            maximumValue = 0.0
            minimumValue = 0.0
            steps = 0.0
            continuous = false
        }
    }
    
    public struct DateConfiguration {
        public var dateFormatter: DateFormatter?
    }
    
    // ADDED - Morgan Le Gal - 03/11/2016 - MAIF-553
    public struct BirthdayConfiguration {
        public var dateFormatter: DateFormatter?
        public var maxAllowedAge: Int?
        public var minAllowedAge: Int?
    }
    // END ADDED
    
    public struct RowConfiguration {
        public var cell:      CellConfiguration
        public var selection: SelectionConfiguration
        public var button:    ButtonConfiguration
        public var stepper:   StepperConfiguration
        public var date:      DateConfiguration
        // ADDED - Morgan Le Gal - 31/10/2016 - MAIF-553
        public var birthday:  BirthdayConfiguration
        // END ADDED
        public var userInfo:  [String : AnyObject]
        
        init() {
            cell = CellConfiguration()
            selection = SelectionConfiguration()
            button = ButtonConfiguration()
            stepper = StepperConfiguration()
            date = DateConfiguration()
            // ADDED - Morgan Le Gal - 31/10/2016 - MAIF-553
            birthday = BirthdayConfiguration()
            // END ADDED
            userInfo = [:]
        }
    }
    
    // MARK: Properties
    
    public let tag: String
    public let type: RowType
    
    public var title: String?
    // ADDED - Romain VINCENS - 20/02/2017 - MAIF-884
    public var subtitle: String?
    // END ADDED
    
    public var value: AnyObject? {
        willSet {
            guard let willUpdateBlock = configuration.cell.willUpdateClosure else { return }
            willUpdateBlock(self)
        }
        didSet {
            guard let didUpdateBlock = configuration.cell.didUpdateClosure else { return }
            didUpdateBlock(self)
        }
    }
    
    public var configuration: RowConfiguration
    
    // MARK: Init
    
    public init(tag: String, type: RowType, title: String, configuration: RowConfiguration) {
        self.tag = tag
        self.type = type
        self.title = title
        self.configuration = configuration
    }
    
    public init(tag: String, type: RowType, title: String) {
        self.tag = tag
        self.type = type
        self.title = title
        self.configuration = RowConfiguration()
    }
    
    // ADDED - Romain VINCENS - 20/02/2017 - MAIF-884
    public init(tag: String, type: RowType, title: String, subtitle: String) {
        self.tag = tag
        self.type = type
        self.title = title
        self.subtitle = subtitle
        self.configuration = RowConfiguration()
    }
    // END ADDED
}
