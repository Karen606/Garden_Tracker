//
//  Date.swift
//  Garden_Tracker
//
//  Created by Karen Khachatryan on 28.10.24.
//

import Foundation

extension Date {
    func toString(format: String = "dd/MM/yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
