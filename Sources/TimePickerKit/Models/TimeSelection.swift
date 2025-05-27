//
//  TimeSelection.swift
//  TimePickerKit
//
//  Created by csk on 2025/5/27.
//

import Foundation

public enum TimeSelection {
    case year(Int)
    case month(year: Int, month: Int)
    case week(startDate: Date, endDate: Date, weekNumber: Int)
    case day(Date)
    
    public var description: String {
        switch self {
        case .year(let year):
            return "\(year)年"
        case .month(let year, let month):
            return "\(year)年\(month)月"
        case .week(let startDate, let endDate, let weekNumber):
            let formatter = DateFormatter()
            formatter.dateFormat = "M月d日"
            return "\(formatter.string(from: startDate)) 至 \(formatter.string(from: endDate)) (第\(weekNumber)周)"
        case .day(let date):
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy年M月d日"
            return formatter.string(from: date)
        }
    }
}
