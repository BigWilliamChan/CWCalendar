//
//  CalendarViewBehavior.swift
//  CWCalendar
//
//  Created by william on 2017/7/25.
//  Copyright © 2017年 陈大威. All rights reserved.
//

import Foundation

struct CalendarViewBehavior {
    static let starterWeekday: Int = CalendarWeekday.sunday.rawValue
    
    static let earliestSelectableDate: CalendarDate? = CalendarDate(day: 1, month: 1, year: 1901) //1901
    
    static let latestSelectableDate: CalendarDate? = CalendarDate(day: 31, month: 12, year: 2099)
}

