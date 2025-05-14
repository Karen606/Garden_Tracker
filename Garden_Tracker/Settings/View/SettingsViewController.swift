//
//  SettingsViewController.swift
//  Garden_Tracker
//
//  Created by Karen Khachatryan on 29.10.24.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var interfaceModeLabel: UILabel!
    @IBOutlet weak var taskNotificationLabel: UILabel!
    @IBOutlet weak var reminderNotificationLabel: UILabel!
    @IBOutlet weak var interfaceModeSwitch: BaseSwitch!
    @IBOutlet weak var tasksNotificationSwitch: BaseSwitch!
    @IBOutlet weak var reminderNotificationsSwitch: BaseSwitch!
    @IBOutlet var sectionButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        interfaceModeLabel.font = .montserratRegular(size: 22)
        taskNotificationLabel.font = .montserratRegular(size: 20)
        reminderNotificationLabel.font = .montserratRegular(size: 20)
        sectionButtons.forEach({ $0.titleLabel?.font = .montserratRegular(size: 20) })
        interfaceModeSwitch.layer.cornerRadius = interfaceModeSwitch.frame.height / 2
        tasksNotificationSwitch.layer.cornerRadius = interfaceModeSwitch.frame.height / 2
        reminderNotificationsSwitch.layer.cornerRadius = interfaceModeSwitch.frame.height / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        interfaceModeSwitch.isOn = UserDefaults.standard.bool(forKey: "isDarkModeEnabled")
        tasksNotificationSwitch.isOn = UserDefaults.standard.bool(forKey: "isTaskNotificationsEnabled")
        reminderNotificationsSwitch.isOn = UserDefaults.standard.bool(forKey: "isReminderNotificationsEnabled")
    }
    
    @IBAction func chooseInterfaceMode(_ sender: BaseSwitch) {
        sender.isOn = sender.isOn
        let interfaceMode = sender.isOn ? UIUserInterfaceStyle.dark : .light
        UserDefaults.standard.set(sender.isOn, forKey: "isDarkModeEnabled")
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            for window in windowScene.windows {
                window.overrideUserInterfaceStyle = interfaceMode
            }
        }
    }

    @IBAction func chooseTasksNotifications(_ sender: BaseSwitch) {
        sender.isOn = sender.isOn
        UserDefaults.standard.set(sender.isOn, forKey: "isTaskNotificationsEnabled")
    }
    
    @IBAction func chooseReminderNotifications(_ sender: BaseSwitch) {
        sender.isOn = sender.isOn
        UserDefaults.standard.set(sender.isOn, forKey: "isReminderNotificationsEnabled")
    }
    
    @IBAction func clickedContactUs(_ sender: UIButton) {
//        if MFMailComposeViewController.canSendMail() {
//            let mailComposeVC = MFMailComposeViewController()
//            mailComposeVC.mailComposeDelegate = self
//            mailComposeVC.setToRecipients(["alina.sverlova6@icloud.com"])
//            present(mailComposeVC, animated: true, completion: nil)
//        } else {
//            let alert = UIAlertController(
//                title: "Mail Not Available",
//                message: "Please configure a Mail account in your settings.",
//                preferredStyle: .alert
//            )
//            alert.addAction(UIAlertAction(title: "OK", style: .default))
//            present(alert, animated: true)
//        }
    }
//
    @IBAction func clickedPrivacyPolicy(_ sender: UIButton) {
//        let privacyVC = PrivacyViewController()
//        privacyVC.url = URL(string: "https://docs.google.com/document/d/1p_yBtClAhyrHDqzp_F3CzFggKrz-a5PItc2JKsjXrhU/mobilebasic")
//        self.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(privacyVC, animated: true)
//        self.hidesBottomBarWhenPushed = false
    }
//
    @IBAction func clickedRateUs(_ sender: UIButton) {
//        let appID = "6742742223"
//        if let url = URL(string: "https://apps.apple.com/app/id\(appID)?action=write-review") {
//            if UIApplication.shared.canOpenURL(url) {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            } else {
//                print("Unable to open App Store URL")
//            }
//        }
    }
}

//
//extension SettingsViewController: MFMailComposeViewControllerDelegate {
//    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        controller.dismiss(animated: true, completion: nil)
//    }
//}

