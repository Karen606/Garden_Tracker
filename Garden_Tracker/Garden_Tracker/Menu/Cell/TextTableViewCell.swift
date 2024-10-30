//
//  TextTableViewCell.swift
//  Garden_Tracker
//
//  Created by Karen Khachatryan on 30.10.24.
//

import UIKit

class TextTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        nameLabel.font = .montserratRegular(size: 20)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupData(record: RecordModel) {
        self.nameLabel.text = "\(record.name ?? "") - \(record.info ?? "")"
    }
    
}
