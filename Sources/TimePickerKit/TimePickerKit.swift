// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import Foundation

public struct TimePickerView: View {
    @State private var timeType: TimeType
    @State private var selectedDate = Date()
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    @State private var selectedMonth = Calendar.current.component(.month, from: Date())
    @State private var selectedWeekIndex = 0
    @State private var selectedDay = Calendar.current.component(.day, from: Date())
    
    private let calendar = Calendar.current
    private let showSegmentedControl: Bool
    private let allowedTimeTypes: [TimeType]
    private let onSelectionChanged: ((TimeSelection) -> Void)?
    
    public init(
        timeType: TimeType = .year,
        showSegmentedControl: Bool = true,
        allowedTimeTypes: [TimeType] = TimeType.allCases,
        onSelectionChanged: ((TimeSelection) -> Void)? = nil
    ) {
        self._timeType = State(initialValue: timeType)
        self.showSegmentedControl = showSegmentedControl
        self.allowedTimeTypes = allowedTimeTypes
        self.onSelectionChanged = onSelectionChanged
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // 顶部分段选择器
            if showSegmentedControl && allowedTimeTypes.count > 1 {
                Picker("Time Type", selection: $timeType) {
                    ForEach(allowedTimeTypes, id: \.self) { type in
                        Text(type.displayName).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .onChange(of: timeType) { _ in
                    updateSelectedValues()
                    notifySelectionChanged()
                }
            }
            
            Spacer()
            
            // 主要选择区域
            VStack(spacing: 20) {
                switch timeType {
                case .year:
                    yearPickerView
                case .month:
                    monthPickerView
                case .week:
                    weekPickerView
                case .day:
                    dayPickerView
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .onAppear {
            updateSelectedValues()
            notifySelectionChanged()
        }
        .frame(height: showSegmentedControl && allowedTimeTypes.count > 1 ? 450 : 400)
    }
    
    // MARK: - Picker Views
    
    private var yearPickerView: some View {
        VStack {
            Picker("Year", selection: $selectedYear) {
                ForEach(2000...2099, id: \.self) { year in
                    Text(String(format: "%d", year))
                        .foregroundColor(.primary)
                        .tag(year)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(height: 300)
            .onChange(of: selectedYear) { _ in
                updateDateFromComponents()
                notifySelectionChanged()
            }
        }
    }
    
    private var monthPickerView: some View {
        VStack {
            HStack(spacing: 0) {
                VStack {
                    Picker("Year", selection: $selectedYear) {
                        ForEach(2000...2099, id: \.self) { year in
                            Text(String(format: "%d", year))
                                .foregroundColor(.primary)
                                .tag(year)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 300)
                    .onChange(of: selectedYear) { _ in
                        updateDateFromComponents()
                        notifySelectionChanged()
                    }
                }
                
                VStack {
                    Picker("Month", selection: $selectedMonth) {
                        ForEach(1...12, id: \.self) { month in
                            Text(getMonthDisplayText(month: month))
                                .foregroundColor(.primary)
                                .tag(month)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 300)
                    .onChange(of: selectedMonth) { _ in
                        updateDateFromComponents()
                        selectedWeekIndex = 0
                        notifySelectionChanged()
                    }
                }
            }
        }
    }
    
    private var weekPickerView: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                VStack {
                    Picker("Year", selection: $selectedYear) {
                        ForEach(2000...2099, id: \.self) { year in
                            Text(String(format: "%d", year))
                                .foregroundColor(.primary)
                                .tag(year)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 100)
                    .onChange(of: selectedYear) { _ in
                        selectedWeekIndex = 0
                        updateDateFromComponents()
                        notifySelectionChanged()
                    }
                }
                
                VStack {
                    Picker("Month", selection: $selectedMonth) {
                        ForEach(1...12, id: \.self) { month in
                            Text(getMonthDisplayText(month: month))
                                .foregroundColor(.primary)
                                .tag(month)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 100)
                    .onChange(of: selectedMonth) { _ in
                        selectedWeekIndex = 0
                        updateDateFromComponents()
                        notifySelectionChanged()
                    }
                }
            }
            
            VStack {
                let weeks = getWeeksInMonth(year: selectedYear, month: selectedMonth)
                
                Picker("Week", selection: $selectedWeekIndex) {
                    ForEach(Array(weeks.enumerated()), id: \.offset) { index, week in
                        Text(week.description)
                            .foregroundColor(.primary)
                            .tag(index)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(height: 200)
                .onChange(of: selectedWeekIndex) { _ in
                    updateDateFromComponents()
                    notifySelectionChanged()
                }
            }
        }
    }
    
    private var dayPickerView: some View {
        VStack {
            HStack(spacing: 0) {
                VStack {
                    Picker("Year", selection: $selectedYear) {
                        ForEach(2000...2099, id: \.self) { year in
                            Text(String(format: "%d", year))
                                .foregroundColor(.primary)
                                .tag(year)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 300)
                    .onChange(of: selectedYear) { _ in
                        updateDateFromComponents()
                        notifySelectionChanged()
                    }
                }
                
                VStack {
                    Picker("Month", selection: $selectedMonth) {
                        ForEach(1...12, id: \.self) { month in
                            Text(getMonthDisplayText(month: month))
                                .foregroundColor(.primary)
                                .tag(month)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 300)
                    .onChange(of: selectedMonth) { _ in
                        updateDateFromComponents()
                        updateDayRange()
                        notifySelectionChanged()
                    }
                }
                
                VStack {
                    Picker("Day", selection: $selectedDay) {
                        ForEach(1...daysInMonth(year: selectedYear, month: selectedMonth), id: \.self) { day in
                            Text(getDayDisplayText(day: day))
                                .foregroundColor(.primary)
                                .tag(day)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 300)
                    .onChange(of: selectedDay) { _ in
                        updateDateFromComponents()
                        notifySelectionChanged()
                    }
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func updateSelectedValues() {
        let components = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        selectedYear = components.year ?? Calendar.current.component(.year, from: Date())
        selectedMonth = components.month ?? Calendar.current.component(.month, from: Date())
        selectedDay = components.day ?? Calendar.current.component(.day, from: Date())
        selectedWeekIndex = 0
    }
    
    private func updateDateFromComponents() {
        var components = DateComponents()
        components.year = selectedYear
        components.month = selectedMonth
        components.day = min(selectedDay, daysInMonth(year: selectedYear, month: selectedMonth))
        
        if let newDate = calendar.date(from: components) {
            selectedDate = newDate
        }
    }
    
    private func updateDayRange() {
        let maxDay = daysInMonth(year: selectedYear, month: selectedMonth)
        if selectedDay > maxDay {
            selectedDay = maxDay
        }
    }
    
    private func daysInMonth(year: Int, month: Int) -> Int {
        var components = DateComponents()
        components.year = year
        components.month = month
        
        if let date = calendar.date(from: components),
           let range = calendar.range(of: .day, in: .month, for: date) {
            return range.count
        }
        return 30
    }
    
    private func getMonthDisplayText(month: Int) -> String {
        let locale = Locale.current
        if locale.language.languageCode?.identifier == "zh" {
            return "\(month)月"
        } else {
            let formatter = DateFormatter()
            formatter.locale = locale
            return formatter.monthSymbols[month - 1]
        }
    }
    
    private func getDayDisplayText(day: Int) -> String {
        let locale = Locale.current
        if locale.language.languageCode?.identifier == "zh" {
            return "\(day)日"
        } else {
            return String(day)
        }
    }
    
    private func getWeeksInMonth(year: Int, month: Int) -> [WeekInfo] {
        var weeks: [WeekInfo] = []
        
        guard let firstDay = calendar.date(from: DateComponents(year: year, month: month, day: 1)),
              let range = calendar.range(of: .day, in: .month, for: firstDay),
              let lastDay = calendar.date(from: DateComponents(year: year, month: month, day: range.count)) else {
            return weeks
        }
        
        var currentDate = firstDay
        var processedWeeks: Set<Int> = []
        
        while currentDate <= lastDay {
            if let weekInterval = calendar.dateInterval(of: .weekOfYear, for: currentDate) {
                let weekOfYear = calendar.component(.weekOfYear, from: currentDate)
                let yearForWeek = calendar.component(.yearForWeekOfYear, from: currentDate)
                let weekIdentifier = yearForWeek * 1000 + weekOfYear
                
                if !processedWeeks.contains(weekIdentifier) {
                    if weekInterval.end > firstDay && weekInterval.start < calendar.date(byAdding: .day, value: 1, to: lastDay)! {
                        let weekInfo = WeekInfo(
                            startDate: weekInterval.start,
                            endDate: calendar.date(byAdding: .second, value: -1, to: weekInterval.end) ?? weekInterval.end,
                            weekNumber: weekOfYear,
                            yearForWeek: yearForWeek
                        )
                        weeks.append(weekInfo)
                        processedWeeks.insert(weekIdentifier)
                    }
                }
            }
            
            guard let nextDay = calendar.date(byAdding: .day, value: 1, to: currentDate) else { break }
            currentDate = nextDay
        }
        
        return weeks.sorted { $0.startDate < $1.startDate }
    }
    
    private func notifySelectionChanged() {
        let selection = getCurrentSelection()
        onSelectionChanged?(selection)
    }
    
    private func getCurrentSelection() -> TimeSelection {
        switch timeType {
        case .year:
            return .year(selectedYear)
        case .month:
            return .month(year: selectedYear, month: selectedMonth)
        case .week:
            let weeks = getWeeksInMonth(year: selectedYear, month: selectedMonth)
            if selectedWeekIndex < weeks.count {
                let week = weeks[selectedWeekIndex]
                return .week(startDate: week.startDate, endDate: week.endDate, weekNumber: week.weekNumber)
            }
            return .month(year: selectedYear, month: selectedMonth)
        case .day:
            return .day(selectedDate)
        }
    }
}

// MARK: - Convenience Extensions

public extension TimePickerView {
    static func yearOnly(onSelectionChanged: ((TimeSelection) -> Void)? = nil) -> TimePickerView {
        TimePickerView(
            timeType: .year,
            showSegmentedControl: false,
            allowedTimeTypes: [.year],
            onSelectionChanged: onSelectionChanged
        )
    }
    
    static func monthOnly(onSelectionChanged: ((TimeSelection) -> Void)? = nil) -> TimePickerView {
        TimePickerView(
            timeType: .month,
            showSegmentedControl: false,
            allowedTimeTypes: [.month],
            onSelectionChanged: onSelectionChanged
        )
    }
    
    static func weekOnly(onSelectionChanged: ((TimeSelection) -> Void)? = nil) -> TimePickerView {
        TimePickerView(
            timeType: .week,
            showSegmentedControl: false,
            allowedTimeTypes: [.week],
            onSelectionChanged: onSelectionChanged
        )
    }
    
    static func dayOnly(onSelectionChanged: ((TimeSelection) -> Void)? = nil) -> TimePickerView {
        TimePickerView(
            timeType: .day,
            showSegmentedControl: false,
            allowedTimeTypes: [.day],
            onSelectionChanged: onSelectionChanged
        )
    }
    
    static func custom(
        timeTypes: [TimeType],
        defaultType: TimeType? = nil,
        onSelectionChanged: ((TimeSelection) -> Void)? = nil
    ) -> TimePickerView {
        let initial = defaultType ?? timeTypes.first ?? .year
        return TimePickerView(
            timeType: initial,
            showSegmentedControl: timeTypes.count > 1,
            allowedTimeTypes: timeTypes,
            onSelectionChanged: onSelectionChanged
        )
    }
}
