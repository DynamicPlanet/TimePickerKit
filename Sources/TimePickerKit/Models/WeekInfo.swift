//
//  WeekInfo.swift
//  TimePickerKit
//
//  Created by csk on 2025/5/27.
//

import Foundation

public struct WeekInfo {
    public let startDate: Date
    public let endDate: Date
    public let weekNumber: Int
    public let yearForWeek: Int
    
    public init(startDate: Date, endDate: Date, weekNumber: Int, yearForWeek: Int) {
        self.startDate = startDate
        self.endDate = endDate
        self.weekNumber = weekNumber
        self.yearForWeek = yearForWeek
    }
    
    public var description: String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        
        let locale = Locale.current
        if locale.language.languageCode?.identifier == "zh" {
            formatter.dateFormat = "M月d日"
            let startString = formatter.string(from: startDate)
            let endString = formatter.string(from: endDate)
            
            let startYear = Calendar.current.component(.year, from: startDate)
            let endYear = Calendar.current.component(.year, from: endDate)
            
            if startYear != endYear {
                return "\(startYear)年\(startString) 至 \(endYear)年\(endString) (第\(weekNumber)周)"
            } else {
                return "\(startString) 至 \(endString) (第\(weekNumber)周)"
            }
        } else {
            formatter.dateFormat = "MMM d"
            let startString = formatter.string(from: startDate)
            let endString = formatter.string(from: endDate)
            
            let startYear = Calendar.current.component(.year, from: startDate)
            let endYear = Calendar.current.component(.year, from: endDate)
            
            if startYear != endYear {
                return "\(startString), \(startYear) to \(endString), \(endYear) (Week \(weekNumber))"
            } else {
                return "\(startString) to \(endString) (Week \(weekNumber))"
            }
        }
    }
}
