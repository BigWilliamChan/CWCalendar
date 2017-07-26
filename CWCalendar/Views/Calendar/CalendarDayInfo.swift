//
//  CalendarDayInfo.swift
//  CWCalendar
//
//  Created by william on 2017/7/25.
//  Copyright © 2017年 陈大威. All rights reserved.
//

import Foundation

class CalendarDayInfo: NSObject {
    var date: CalendarDate!
    
    weak var weekInfo: CalendarWeekInfo!
    let weekdayIndex: Int
    
    var isOut = false
    var isDisabled = false
    
    var dayStatus: DayStatus {
        if isDisabled { return .disabled }
        else if isOut { return .out }
        return .in
    }
    
    var weekday: CalendarWeekday {
        return self.date?.weekDay() ?? .monday
    }
    
    
    weak var monthInfo: CalendarMonthInfo! {
        var monthInfo: CalendarMonthInfo!
        if let weekInfo = weekInfo, let activeMonthInfo = weekInfo.monthInfo {
            monthInfo = activeMonthInfo
        }
        
        return monthInfo
    }
    
    init(weekInfo: CalendarWeekInfo, weekdayIndex: Int) {
        
        self.weekInfo = weekInfo
        self.weekdayIndex = weekdayIndex
        
        super.init()
        
        date = date(withWeekdayInfo: weekInfo)
        
        if let earliestSelectableDate = CalendarViewBehavior.earliestSelectableDate, matchedDays(date, earliestSelectableDate){
            monthInfo.allowScrollToPreviousMonth = false
        }
        
        if let latestSelectableDate = CalendarViewBehavior.latestSelectableDate, matchedDays(date, latestSelectableDate) {
            monthInfo.allowScrollToNextMonth = false
        }
        
        if let earliestSelectableDate = CalendarViewBehavior.earliestSelectableDate, date.compare(earliestSelectableDate) == .orderedAscending {
            isDisabled = true
        }
        
        if let latestSelectableDate = CalendarViewBehavior.latestSelectableDate, date.compare(latestSelectableDate) == .orderedDescending {
            isDisabled = true
        }
    }
}

extension CalendarDayInfo {
    func date(withWeekdayInfo weekInfo: CalendarWeekInfo) -> CalendarDate {
        func hasDayAtWeekdayIndex(_ weekdayIndex: Int, weekdaysDictionary: [Int : [Int]]) -> Bool {
            for key in weekdaysDictionary.keys {
                if key == weekdayIndex {
                    return true
                }
            }
            
            return false
        }
        
        var day: Int!
        let weekdaysIn = weekInfo.weekdaysIn
        
        if let weekdaysOut = weekInfo.weekdaysOut {
            if hasDayAtWeekdayIndex(weekdayIndex, weekdaysDictionary: weekdaysOut) {
                isOut = true
                day = weekdaysOut[weekdayIndex]![0]
            } else if hasDayAtWeekdayIndex(weekdayIndex, weekdaysDictionary: weekdaysIn!) {
                day = weekdaysIn![weekdayIndex]![0]
            }
        } else {
            day = weekdaysIn![weekdayIndex]![0]
        }
        
        let dateRange = Manager.dateRange(monthInfo.date)
        var year = dateRange.year
        let week = weekInfo.index + 1
        var month = dateRange.month
        
        if isOut {
            day > 20 ? (month -= 1) : (month += 1)
            if month == 0 {
                month = 12
                year -= 1
            } else if month == 13 {
                month = 1
                year += 1
            }
        }
        
        return CalendarDate(day: day, month: month, week: week, year: year)
    }
}
