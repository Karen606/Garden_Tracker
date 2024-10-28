//
//  ViewController.swift
//  Garden_Tracker
//
//  Created by Karen Khachatryan on 28.10.24.
//

import UIKit

extension UIViewController {
    func setNavigationTitle(title: String) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .black
        titleLabel.font = .angkor(size: 22)
        titleLabel.textAlignment = .center
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
    }
    
    func setNaviagtionCloseButton() {
        let backButton = UIButton(type: .custom)
//        backButton.setImage(UIImage.close, for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.addTarget(self, action: #selector(clickedBack), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @objc func clickedBack() {
        navigationController?.popViewController(animated: true)
    }
        
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    func pushViewController<T: UIViewController>(_ viewControllerType: T.Type, animated: Bool = true) {
        let nibName = String(describing: viewControllerType)
        let viewController = T(nibName: nibName, bundle: nil)
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view // Your source view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        present(alertController, animated: true, completion: nil)
    }
}

