//
//  CalendarDate.swift
//  CWCalendar
//
//  Created by william on 2017/7/25.
//  Copyright © 2017年 陈大威. All rights reserved.
//

import UIKit

class CalendarDate: NSObject {
    fileprivate let date: Foundation.Date
    fileprivate let maxDate: Date = Date(year: 2099, month: 12, day: 31)!
    fileprivate let minDate: Date = Date(year: 1901, month: 1, day: 1)!
    
    
    public let year: Int
    public let month: Int
    public let week: Int //weekOfMonth
    public let day: Int
    
    public let weekOfYear: Int //在一年中的第几周
    
    public init(date: Foundation.Date, calendar: Calendar = Calendar.current) {
        let dateRange = Manager.dateRange(date, calendar: calendar)
        
        self.date = date
        self.year = dateRange.year
        self.month = dateRange.month
        self.week = dateRange.weekOfMonth
        self.day = dateRange.day
        self.weekOfYear = dateRange.weekOfYear
        super.init()
    }
    
    public init(day: Int, month: Int, year: Int, calendar: Calendar = Calendar.current) {
        
        if let date = Manager.dateFromYear(year, month: month, day: day, calendar: calendar) {
            self.date = date
        } else {
            self.date = Foundation.Date()
        }
        
        self.year = year
        self.month = month
        self.week = calendar.component(.weekOfMonth, from: self.date)
        self.day = day
        self.weekOfYear = calendar.component(.weekOfYear, from: self.date)
        super.init()
    }
    
    public init(day: Int, month: Int, week: Int, year: Int, calendar: Calendar = Calendar.current) {
        
        if let date = Manager.dateFromYear(year, month: month, day: day, calendar: calendar) {
            self.date = date
        } else {
            self.date = Foundation.Date()
        }
        
        self.year = year
        self.month = month
        self.week = week
        self.day = day
        self.weekOfYear = calendar.component(.weekOfYear, from: self.date)
        super.init()
    }
}

extension CalendarDate {
    public func weekDay(calendar: Calendar = Calendar.current) -> CalendarWeekday? {
        let weekday = calendar.component(.weekday, from: date)
        return CalendarWeekday(rawValue: weekday)
    }
    
    func isMinDay() -> Bool {
        if self.year == minDate.year , self.month == minDate.month, self.day == minDate.day {
            return true
        }
        return false
    }
    func isMaxDay() -> Bool {
        if self.year == maxDate.year , self.month == maxDate.month, self.day == maxDate.day {
            return true
        }
        return false
    }
    
    public func weekDay(calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(.weekday, from: date)
    }
    
    public var isToday: Bool {
        let currentDateRange = Manager.dateRange(Date(), calendar: Calendar.current)
        return currentDateRange.day == self.day && currentDateRange.month == self.month && currentDateRange.year == self.year
    }
    
    public var hour: Int? {
        return self.date.hour
    }
    
    public var tomorrow: CalendarDate? {
        let tomorrowDate = self.date.tomorrow
        if tomorrowDate == nil || tomorrowDate! > self.maxDate {
            return nil
        }
        return CalendarDate(date: tomorrowDate!)
    }
    
    public var yesterday: CalendarDate? {
        let yesterdayDate = self.date.yesterday
        if yesterdayDate == nil || yesterdayDate! < self.minDate {
            return nil
        }
        return CalendarDate(date: yesterdayDate!)
    }
    
    public func compare(_ another: CalendarDate) -> ComparisonResult {
        if year < another.year {
            return .orderedAscending
        } else if year > another.year {
            return .orderedDescending
        } else {
            if month < another.month {
                return .orderedAscending
            } else if month > another.month {
                return .orderedDescending
            } else {
                if day < another.day {
                    return .orderedAscending
                } else if day > another.day {
                    return .orderedDescending
                } else {
                    return .orderedSame
                }
            }
        }
    }
    
    public var firstDayOfMonth: CalendarDate {
        let firstDay = date.firstDayOfMonth
        return CalendarDate.init(date: firstDay!)
    }
    
    
    public func convertedDate(calendar: Calendar = Calendar.current) -> Foundation.Date? {
        var comps = Manager.componentsForDate(Foundation.Date(), calendar: calendar)
        
        comps.year = year
        comps.month = month
        comps.weekOfMonth = week
        comps.day = day
        
        return calendar.date(from: comps)
    }
    public var UTCDate: Date {
        return self.date
    }
}

func matchedMonths(_ lhs: CalendarDate, _ rhs: CalendarDate) -> Bool {
    return lhs.year == rhs.year && lhs.month == rhs.month
}

func matchedDays(_ lhs: CalendarDate, _ rhs: CalendarDate) -> Bool {
    return (lhs.year == rhs.year && lhs.month == rhs.month && lhs.day == rhs.day)
}
