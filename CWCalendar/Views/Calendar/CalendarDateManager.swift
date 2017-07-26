//
//  CalendarDateManager.swift
//  CWCalendar
//
//  Created by william on 2017/7/25.
//  Copyright © 2017年 陈大威. All rights reserved.
//

import UIKit

typealias Manager = CalendarDateManager

public final class CalendarDateManager {
    // MARK: - Private properties
    fileprivate var components: DateComponents
    fileprivate var calendar = Calendar.current
    
    // MARK: - Public properties
    var currentDate: Foundation.Date
    
    // MARK: - Private initialization
    
    let starterWeekday: Int = CalendarViewBehavior.starterWeekday
    
    init() {
        currentDate = Foundation.Date()
        components = calendar.dateComponents([.month, .day], from: currentDate)
    }
    
    // MARK: - Common date analysis
    
    public func monthDateRange(_ date: Foundation.Date) -> (countOfWeeks: NSInteger,
        monthStartDate: Foundation.Date, monthEndDate: Foundation.Date) {
            calendar.firstWeekday = starterWeekday
            
            var components = calendar.dateComponents([.year, .month, .weekOfMonth], from: date)
            
            // Start of the month.
            components.day = 1
            let monthStartDate = calendar.date(from: components)!
            
            // End of the month.
            components.month! += 1
            components.day! -= 1
            let monthEndDate = calendar.date(from: components)!
            
            // Range of the month.
            let range = calendar.range(of: .weekOfMonth, in: .month, for: date)
            let countOfWeeks = range?.count
            
            return (countOfWeeks!, monthStartDate, monthEndDate)
    }
    
    public static func dateRange(_ date: Foundation.Date, calendar: Calendar = Calendar.current) ->
        (year: Int, month: Int, weekOfMonth: Int, day: Int, weekOfYear: Int) {
            let components = componentsForDate(date, calendar: calendar)
            
            let year = components.year
            let month = components.month
            let weekOfMonth = components.weekOfMonth
            let day = components.day
            let weekOfYear = components.weekOfYear
            
            
            return (year!, month!, weekOfMonth!, day!, (weekOfYear ?? 0 ))
    }
    
    public func weekdayForDate(_ date: Foundation.Date) -> Int {
        
        calendar.firstWeekday = starterWeekday
        
        let weekday = calendar.component(.weekday, from: date)
        
        return Int(weekday)
    }
    
    // MARK: - Analysis sorting
    
    public func weeksWithWeekdaysForMonthDate(_ date: Foundation.Date) ->
        (weeksIn: [[Int : [Int]]], weeksOut: [[Int : [Int]]]) {
            
            calendar.firstWeekday = starterWeekday
            
            let countOfWeeks = self.monthDateRange(date).countOfWeeks
            let totalCountOfDays = countOfWeeks * 7
            let firstMonthDateIn = self.monthDateRange(date).monthStartDate
            let lastMonthDateIn = self.monthDateRange(date).monthEndDate
            let countOfDaysIn = Manager.dateRange(lastMonthDateIn, calendar: calendar).day
            let countOfDaysOut = totalCountOfDays - countOfDaysIn
            
            // Find all dates in.
            var datesIn = [NSDate]()
            for day in 1...countOfDaysIn {
                var components = Manager.componentsForDate(firstMonthDateIn, calendar: calendar)
                components.day = day
                let date = calendar.date(from: components)!
                datesIn.append(date as NSDate)
            }
            
            // Find all dates out.
            
            let firstMonthDateOut: Foundation.Date? = {
                let firstMonthDateInWeekday = self.weekdayForDate(firstMonthDateIn)
                if firstMonthDateInWeekday == self.starterWeekday {
                    return firstMonthDateIn
                }
                
                var components = Manager.componentsForDate(firstMonthDateIn, calendar: calendar)
                for _ in 1...7 {
                    components.day! -= 1
                    
                    
                    let updatedDate = calendar.date(from: components)!
                    let updatedDateWeekday = self.weekdayForDate(updatedDate)
                    if updatedDateWeekday == self.starterWeekday {
                        return updatedDate
                    }
                }
                
                let diff = 7 - firstMonthDateInWeekday
                for _ in diff..<7 {
                    components.day! += 1
                    let updatedDate = calendar.date(from: components)!
                    let updatedDateWeekday = self.weekdayForDate(updatedDate)
                    if updatedDateWeekday == self.starterWeekday {
                        return updatedDate
                    }
                }
                
                return nil
            }()
            
            // Constructing weeks.
            
            var firstWeekDates = [NSDate]()
            var lastWeekDates = [NSDate]()
            
            var firstWeekDate = (firstMonthDateOut != nil) ? firstMonthDateOut! : firstMonthDateIn
            var components = Manager.componentsForDate(firstWeekDate, calendar: calendar)
            components.day! += 6
            var lastWeekDate = calendar.date(from: components)!
            
            func nextWeekDateFromDate(_ date: Foundation.Date) -> Foundation.Date {
                var components = Manager.componentsForDate(date, calendar: calendar)
                components.day! += 7
                let nextWeekDate = calendar.date(from: components)!
                return nextWeekDate
            }
            
            for weekIndex in 1...countOfWeeks {
                firstWeekDates.append(firstWeekDate as NSDate)
                lastWeekDates.append(lastWeekDate as NSDate)
                
                firstWeekDate = nextWeekDateFromDate(firstWeekDate)
                lastWeekDate = nextWeekDateFromDate(lastWeekDate)
            }
            
            // Dictionaries.
            
            var weeksIn = [[Int : [Int]]]()
            var weeksOut = [[Int : [Int]]]()
            
            let count = firstWeekDates.count
            
            for i in 0..<count {
                var weekdaysIn = [Int : [Int]]()
                var weekdaysOut = [Int : [Int]]()
                
                let firstWeekDate = firstWeekDates[i]
                let lastWeekDate = lastWeekDates[i]
                
                var components = Manager.componentsForDate(firstWeekDate as Foundation.Date, calendar: calendar)
                for weekday in 1...7 {
                    let weekdate = calendar.date(from: components)!
                    components.day! += 1
                    let day = Manager.dateRange(weekdate, calendar: calendar).day
                    
                    func addDay(_ weekdays: inout [Int : [Int]]) {
                        var days = weekdays[weekday]
                        if days == nil {
                            days = [Int]()
                        }
                        
                        days!.append(day)
                        weekdays.updateValue(days!, forKey: weekday)
                    }
                    
                    if i == 0 && day > 20 {
                        addDay(&weekdaysOut)
                    } else if i == countOfWeeks - 1 && day < 10 {
                        addDay(&weekdaysOut)
                        
                    } else {
                        addDay(&weekdaysIn)
                    }
                }
                
                if !weekdaysIn.isEmpty {
                    weeksIn.append(weekdaysIn)
                }
                
                if !weekdaysOut.isEmpty {
                    weeksOut.append(weekdaysOut)
                }
            }
            
            return (weeksIn, weeksOut)
    }
    
    // MARK: - Util methods
    
    public static func componentsForDate(_ date: Foundation.Date, calendar: Calendar = Calendar.current) -> DateComponents {
        
        let components = calendar.dateComponents([.year, .month, .weekOfMonth, .day], from: date)
        
        return components
    }
    
    public static func dateFromYear(_ year: Int, month: Int, week: Int, day: Int, calendar: Calendar) -> Foundation.Date? {
        var comps = Manager.componentsForDate(Foundation.Date(), calendar: calendar)
        comps.year = year
        comps.month = month
        comps.weekOfMonth = week
        comps.day = day
        
        return calendar.date(from: comps)
    }
    
    public static func dateFromYear(_ year: Int, month: Int, day: Int, calendar: Calendar = Calendar.current) -> Foundation.Date? {
        var comps = Manager.componentsForDate(Foundation.Date(), calendar: calendar)
        comps.year = year
        comps.month = month
        comps.day = day
        
        return calendar.date(from: comps)
    }
    
    public func date(after noOfDays: Int, from baseDate: Date) -> Date! {
        var dayComponents = DateComponents()
        dayComponents.day = noOfDays
        return calendar.date(byAdding: dayComponents, to: baseDate)
    }
}

var dateManager = Manager()

