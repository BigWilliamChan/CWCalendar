//
//  CalendarExtensions.swift
//  CWCalendar
//
//  Created by william on 2017/7/25.
//  Copyright © 2017年 陈大威. All rights reserved.
//

import Foundation

extension Calendar {
    public static let gregorian: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        let timeZone = TimeZone(abbreviation: "UTC")!
        calendar.timeZone = timeZone
        return calendar
    }()
}

let gregorianCalendar = Calendar.gregorian

var currentDateComps = gregorianCalendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Foundation.Date())
