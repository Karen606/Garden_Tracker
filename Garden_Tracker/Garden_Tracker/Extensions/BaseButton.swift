//
//  BaseButton.swift
//  Garden_Tracker
//
//  Created by Karen Khachatryan on 28.10.24.
//

import UIKit

class BaseButton: UIButton {
    
    override var isEnabled: Bool {
        didSet {
            self.backgroundColor = isEnabled ? self.backgroundColor?.withAlphaComponent(1) : self.backgroundColor?.withAlphaComponent(0.4)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        self.titleLabel?.font = .montserratBold(size: 16)
        self.setTitleColor(.white, for: .normal)
        self.layer.cornerRadius = 12
        self.backgroundColor = .button
        self.addShadow()
    }
}
