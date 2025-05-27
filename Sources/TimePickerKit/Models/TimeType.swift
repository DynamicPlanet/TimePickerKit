//
//  TimeType.swift
//  TimePickerKit
//
//  Created by csk on 2025/5/27.
//

import Foundation

public enum TimeType: String, CaseIterable {
    case year = "year"
    case month = "month"
    case week = "week"
    case day = "day"
    
    public var displayName: String {
        switch self {
        case .year: return "年"
        case .month: return "月"
        case .week: return "周"
        case .day: return "日"
        }
    }
}
