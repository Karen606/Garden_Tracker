//
//  BaseSwitch.swift
//  Garden_Tracker
//
//  Created by Karen Khachatryan on 29.10.24.
//

import UIKit

class BaseSwitch: UISwitch {
    override var isOn: Bool {
        didSet {
            self.thumbTintColor = isOn ? .switchOn : .switchOff
        }
    }
}
