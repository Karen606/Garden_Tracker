//
//  tabBarViewController.swift
//  Garden_Tracker
//
//  Created by Karen Khachatryan on 28.10.24.
//

import UIKit

class tabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addTopBorder()
    }
    
    private func addTopBorder() {
        let border = CALayer()
        border.backgroundColor = UIColor.black.cgColor
        border.frame = CGRect(x: 0, y: 0, width: tabBar.frame.size.width, height: 1.0)
        tabBar.layer.addSublayer(border)
    }
}
