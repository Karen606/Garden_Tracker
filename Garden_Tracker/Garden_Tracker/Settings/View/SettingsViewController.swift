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
        interfaceModeSwitch.isOn = UserDefaults.standard.bool(forKey: "isDarkModeEnabled")
        interfaceModeLabel.font = .montserratRegular(size: 22)
        taskNotificationLabel.font = .montserratRegular(size: 20)
        taskNotificationLabel.font = .montserratRegular(size: 20)
        sectionButtons.forEach({ $0.titleLabel?.font = .montserratRegular(size: 20) })
        interfaceModeSwitch.layer.cornerRadius = interfaceModeSwitch.frame.height / 2
        tasksNotificationSwitch.layer.cornerRadius = interfaceModeSwitch.frame.height / 2
        reminderNotificationsSwitch.layer.cornerRadius = interfaceModeSwitch.frame.height / 2
    }
    
    @IBAction func chooseInterfaceMode(_ sender: BaseSwitch) {
        sender.isOn = sender.isOn
        tabBarController?.overrideUserInterfaceStyle = sender.isOn ? .dark : .light
        UserDefaults.standard.set(sender.isOn, forKey: "isDarkModeEnabled")
    }

    @IBAction func chooseTasksNotifications(_ sender: BaseSwitch) {
        sender.isOn = sender.isOn

    }
    
    @IBAction func chooseReminderNotifications(_ sender: BaseSwitch) {
        sender.isOn = sender.isOn
    }
    
    @IBAction func clickedContactUs(_ sender: UIButton) {
    }
    
    @IBAction func clickedPrivacyPolicy(_ sender: UIButton) {
    }
    
    @IBAction func clickedRateUs(_ sender: UIButton) {
    }
}
