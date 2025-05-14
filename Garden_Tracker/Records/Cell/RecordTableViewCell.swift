//
//  RecordTableViewCell.swift
//  Garden_Tracker
//
//  Created by Karen Khachatryan on 29.10.24.
//

import UIKit

protocol RecordTableViewCellDelegate: AnyObject {
    func editRecord(record: RecordModel)
    func removeRecord(recordID: UUID)
}

class RecordTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    weak var delegate: RecordTableViewCellDelegate?
    private var record: RecordModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        nameLabel.font = .montserratMedium(size: 14)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func prepareForReuse() {
        record = nil
    }
    
    func setupData(record: RecordModel) {
        self.record = record
        self.nameLabel.text = "\(record.date?.toString(format: "dd/MM/yy") ?? "")  \(record.info ?? "")"
    }
    
    @IBAction func clickedEdit(_ sender: UIButton) {
        if let record = record {
            delegate?.editRecord(record: record)
        }
    }
    
    @IBAction func clickedRemove(_ sender: UIButton) {
        if let id = record?.id {
            delegate?.removeRecord(recordID: id)
        }
    }
}
