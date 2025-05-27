# TimePickerKit

一个用于 SwiftUI 的灵活时间选择器组件包，支持年、月、周、日四种时间选择模式。

## 特性

- 🎯 **四种时间类型**: 年份、月份、周、日期
- 🔧 **灵活配置**: 可以单独显示某种类型或组合显示
- 🌍 **国际化支持**: 支持中英文本地化
- 📅 **准确的周计算**: 使用系统标准的周计算方法
- 🎨 **简洁UI**: 无多余标签，界面简洁
- 📦 **回调支持**: 实时监听选择变化

## 安装

### Swift Package Manager

在 Xcode 中：
1. File → Add Package Dependencies...
2. 输入包的 URL
3. 选择版本并添加到项目

或在 `Package.swift` 中添加：

```swift
dependencies: [
    .package(url: "https://github.com/your-username/TimePickerKit.git", from: "1.0.0")
]
```

## 基本使用

### 导入包

```swift
import TimePickerKit
```

### 完整的时间选择器

```swift
struct ContentView: View {
    var body: some View {
        TimePickerView { selection in
            print("选择了: \(selection.description)")
        }
    }
}
```

### 单一类型选择器

```swift
// 只显示年份选择器
TimePickerView.yearOnly { selection in
    if case .year(let year) = selection {
        print("选择的年份: \(year)")
    }
}

// 只显示月份选择器
TimePickerView.monthOnly { selection in
    if case .month(let year, let month) = selection {
        print("选择的月份: \(year)年\(month)月")
    }
}

// 只显示周选择器
TimePickerView.weekOnly { selection in
    if case .week(let start, let end, let weekNumber) = selection {
        print("选择的周: 第\(weekNumber)周，从\(start)到\(end)")
    }
}

// 只显示日期选择器
TimePickerView.dayOnly { selection in
    if case .day(let date) = selection {
        print("选择的日期: \(date)")
    }
}
```

### 自定义组合

```swift
// 只显示年份和月份
TimePickerView.custom(
    timeTypes: [.year, .month],
    defaultType: .month
) { selection in
    print("选择: \(selection.description)")
}

// 只显示周和日
TimePickerView.custom(
    timeTypes: [.week, .day],
    defaultType: .week
) { selection in
    print("选择: \(selection.description)")
}
```

### 高级配置

```swift
TimePickerView(
    timeType: .month,                    // 默认显示类型
    showSegmentedControl: true,          // 是否显示分段控制器
    allowedTimeTypes: [.month, .day],    // 允许的时间类型
    onSelectionChanged: { selection in   // 选择变化回调
        switch selection {
        case .year(let year):
            print("年份: \(year)")
        case .month(let year, let month):
            print("月份: \(year)年\(month)月")
        case .week(let start, let end, let weekNumber):
            print("周: 第\(weekNumber)周")
        case .day(let date):
            print("日期: \(date)")
        }
    }
)
```

## API 文档

### TimePickerView

主要的时间选择器视图组件。

#### 初始化参数

- `timeType: TimeType` - 默认显示的时间类型
- `showSegmentedControl: Bool` - 是否显示分段控制器
- `allowedTimeTypes: [TimeType]` - 允许选择的时间类型数组
- `onSelectionChanged: ((TimeSelection) -> Void)?` - 选择变化回调

#### 便利方法

- `TimePickerView.yearOnly()` - 创建只显示年份的选择器
- `TimePickerView.monthOnly()` - 创建只显示月份的选择器
- `TimePickerView.weekOnly()` - 创建只显示周的选择器
- `TimePickerView.dayOnly()` - 创建只显示日期的选择器
- `TimePickerView.custom()` - 创建自定义组合的选择器

### TimeType

时间类型枚举。

```swift
public enum TimeType: String, CaseIterable {
    case year = "year"
    case month = "month"
    case week = "week"
    case day = "day"
}
```

### TimeSelection

时间选择结果枚举。

```swift
public enum TimeSelection {
    case year(Int)
    case month(year: Int, month: Int)
    case week(startDate: Date, endDate: Date, weekNumber: Int)
    case day(Date)
}
```

### WeekInfo

周信息结构体。

```swift
public struct WeekInfo {
    public let startDate: Date
    public let endDate: Date
    public let weekNumber: Int
    public let yearForWeek: Int
}
```

## 示例项目

### 基础示例

```swift
import SwiftUI
import TimePickerKit

struct ContentView: View {
    @State private var selectedTime: String = "未选择"
    
    var body: some View {
        VStack {
            Text("当前选择: \(selectedTime)")
                .padding()
            
            TimePickerView { selection in
                selectedTime = selection.description
            }
        }
    }
}
```

### 多个选择器组合

```swift
struct MultiPickerView: View {
    @State private var yearSelection: String = ""
    @State private var monthSelection: String = ""
    
    var body: some View {
        VStack {
            VStack {
                Text("年份选择: \(yearSelection)")
                TimePickerView.yearOnly { selection in
                    yearSelection = selection.description
                }
                .frame(height: 200)
            }
            
            Divider()
            
            VStack {
                Text("月份选择: \(monthSelection)")
                TimePickerView.monthOnly { selection in
                    monthSelection = selection.description
                }
                .frame(height: 200)
            }
        }
    }
}
```

## 本地化

包已内置中英文支持：

- 中文环境：显示 "年"、"月"、"周"、"日"
- 英文环境：显示 "Year"、"Month"、"Week"、"Day"

月份和日期显示也会根据系统语言自动调整。

## 系统要求

- iOS 14.0+
- macOS 11.0+
- watchOS 7.0+
- tvOS 14.0+
- Swift 5.9+

## 贡献

欢迎提交 Issues 和 Pull Requests！

## 许可证

MIT License

---

## 更新日志

### v1.0.0
- 初始版本发布
- 支持年、月、周、日四种时间选择
- 提供便利构造方法
- 支持实时回调
- 内置国际化支持
