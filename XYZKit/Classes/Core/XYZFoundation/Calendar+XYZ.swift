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
        let df = DateFormatter(format: format)
        return df.string(from: self)
    }
}
