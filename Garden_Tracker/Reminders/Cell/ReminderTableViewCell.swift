//
//  ReminderTableViewCell.swift
//  Garden_Tracker
//
//  Created by Karen Khachatryan on 29.10.24.
//

import UIKit

class ReminderTableViewCell: UITableViewCell {

    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        reminderLabel.font = .montserratRegular(size: 20)
        dateLabel.font = .montserratRegular(size: 20)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupData(reminder: ReminderModel) {
        reminderLabel.text = reminder.info
        dateLabel.text = reminder.date?.toString(format: "dd/MM/yy")
    }
    
}
