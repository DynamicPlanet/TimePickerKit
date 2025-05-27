import XCTest
@testable import TimePickerKit

final class TimePickerKitTests: XCTestCase {
    
    func testTimeTypeDisplayNames() {
        XCTAssertEqual(TimeType.year.displayName, "年")
        XCTAssertEqual(TimeType.month.displayName, "月")
        XCTAssertEqual(TimeType.week.displayName, "周")
        XCTAssertEqual(TimeType.day.displayName, "日")
    }
    
    func testTimeSelectionDescription() {
        let yearSelection = TimeSelection.year(2024)
        XCTAssertEqual(yearSelection.description, "2024年")
        
        let monthSelection = TimeSelection.month(year: 2024, month: 5)
        XCTAssertEqual(monthSelection.description, "2024年5月")
        
        let daySelection = TimeSelection.day(Date())
        XCTAssertFalse(daySelection.description.isEmpty)
    }
    
    func testWeekInfoCreation() {
        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: .day, value: 6, to: startDate)!
        
        let weekInfo = WeekInfo(
            startDate: startDate,
            endDate: endDate,
            weekNumber: 20,
            yearForWeek: 2024
        )
        
        XCTAssertEqual(weekInfo.weekNumber, 20)
        XCTAssertEqual(weekInfo.yearForWeek, 2024)
        XCTAssertFalse(weekInfo.description.isEmpty)
    }
}
