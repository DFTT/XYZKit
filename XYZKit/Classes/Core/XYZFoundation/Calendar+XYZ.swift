//
//  Calendar+XYZ.swift
//  UniTok
//
//  Created by 大大东 on 2023/11/1.
//

import Foundation

/*
 防止有的手机 语言与地区 -> 日历 被修改为非公历, 导致DatePicker DateFormat错误
 */

public extension Calendar {
    // 公历
    static let gregorian = Calendar(identifier: .gregorian)
}

public extension DateFormatter {
    convenience init(format: String, calendar: Calendar = Calendar.gregorian) {
        self.init()
        self.dateFormat = format
        self.calendar = calendar
    }
}

public extension Date {
    func format(with format: String, calendar: Calendar = Calendar.gregorian) -> String {
        let df = DateFormatter(format: format, calendar: calendar)
        return df.string(from: self)
    }

    func compts() -> (year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) {
        let coms = Calendar.gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        return (coms.year ?? 0, coms.month ?? 0, coms.day ?? 0, coms.hour ?? 0, coms.minute ?? 0, coms.second ?? 0)
    }

    func isToday() -> Bool {
        return Calendar.gregorian.isDateInToday(self)
    }

    func isYesterday() -> Bool {
        return Calendar.gregorian.isDateInYesterday(self)
    }

    func isTomorrow() -> Bool {
        return Calendar.gregorian.isDateInTomorrow(self)
    }

    func isSameDay(as date: Date) -> Bool {
        return Calendar.gregorian.isDate(self, inSameDayAs: date)
    }

    //
    func adding(_ component: Calendar.Component, value: Int) -> Date? {
        return Calendar.gregorian.date(byAdding: component, value: value, to: self)
    }

    // 今天 00:00:00
    func startOfDay() -> Date {
        return Calendar.gregorian.startOfDay(for: self)
    }

    // 今天 23:59:59
    func endOfDay() -> Date? {
        return Calendar.gregorian.date(bySettingHour: 23, minute: 59, second: 59, of: self)
    }
}
