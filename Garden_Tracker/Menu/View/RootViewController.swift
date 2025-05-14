//
//  RootViewController.swift
//  Garden_Tracker
//
//  Created by Karen Khachatryan on 14.05.25.
//


import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let tabBarVC = tabBarViewController()
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = tabBarVC
            window.makeKeyAndVisible()
        }
    }
}
