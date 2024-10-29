//
//  tabBarViewController.swift
//  Garden_Tracker
//
//  Created by Karen Khachatryan on 28.10.24.
//

import UIKit

class tabBarViewController: UITabBarController {
    let border = CALayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        addTopBorder()
        self.tabBar.backgroundColor = .baseWhiteText
    }
    
    private func addTopBorder() {
        border.backgroundColor = UIColor.baseBlackText.cgColor
        border.frame = CGRect(x: 0, y: 0, width: tabBar.frame.size.width, height: 1.0)
        tabBar.layer.addSublayer(border)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            border.backgroundColor = (previousTraitCollection?.userInterfaceStyle == .light) ? UIColor.black.cgColor : UIColor.white.cgColor
            
        }
    }
}
