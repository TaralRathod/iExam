//
//  DateFormatter + Extension.swift
//  iExam
//
//  Created by Taral Rathod on 01/02/22.
//

import Foundation

extension DateComponentsFormatter {
    func difference(from fromDate: Date, to toDate: Date) -> String? {
        self.allowedUnits = [.year,.month,.weekOfMonth,.day]
        self.maximumUnitCount = 1
        self.unitsStyle = .full
        return self.string(from: fromDate, to: toDate)
    }
}
