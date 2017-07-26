//
//  DateUtils.swift
//  CWCalendar
//
//  Created by william on 2017/7/25.
//  Copyright © 2017年 陈大威. All rights reserved.
//

import Foundation


private let weekdayChars = ["星期日","星期一","星期二","星期三","星期四","星期五","星期六"]

func UTC(_ year: Int, _ month: Int, _ day: Int, _ hour: Int = 0, _ minute: Int = 0, _ second: Int = 0) -> Int64 {
    
    currentDateComps.year = year
    currentDateComps.month = month
    currentDateComps.day = day
    currentDateComps.hour = hour
    currentDateComps.minute = minute
    currentDateComps.second = second
    
    let date = gregorianCalendar.date(from: currentDateComps)!
    
    let nowDouble = date.timeIntervalSince1970
    
    return Int64(nowDouble * 1000)
}

func weekdayText(_ weekday: Int) -> String {
    var week = weekday
    if week >= weekdayChars.count {
        week = 7 //sunday
    }
    return weekdayChars[week - 1]
}

func weekdayText(_ date: Date, calendar: Calendar = Calendar.current) -> String {
    var week = calendar.component(.weekday, from: date)
    if week > weekdayChars.count {
        week = 7
    }
    return weekdayChars[week - 1]
}

func numberOfDaysBetween(_ startDate: Date, _ endDate: Date, calendar: Calendar = Calendar.current) -> Int {
    let components = calendar.dateComponents([.day], from: startDate, to: endDate)
    return components.day! + 1 //需要加，否则这样算出来的是完全的差
}

func components(from date: Date, calendar: Calendar = Calendar.current) -> (Int, Int, Int) {
    
    let components = calendar.dateComponents([.year, .month, .day], from: date)
    
    return (components.year!, components.month!, components.day!)
}

func daysInMonth(withYear year: Int, month: Int, calendar: Calendar = Calendar.current) -> Int {
    let dayComponents = DateComponents(year: year, month: month)
    let date = calendar.date(from: dayComponents)
    
    let range = calendar.range(of: .day, in: .month, for: date!)!
    return range.count
}

func createDate(fromYear year: Int, month: Int, day: Int, calendar: Calendar = Calendar.current) -> Foundation.Date {
    var components = calendar.dateComponents([.year, .month, .day], from: Date())
    components.year = year
    components.month = month
    components.day = day
    return calendar.date(from: components)!
}

func createDate(fromYear year: Int, month: Int, day: Int, hour: Int, mimute: Int, second: Int, calendar: Calendar = Calendar.current) -> Foundation.Date {
    var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
    components.year = year
    components.month = month
    components.day = day
    components.hour = hour
    components.minute = mimute
    components.second = second
    return calendar.date(from: components)!
}

func isToday(_ date: Date) -> Bool {
    let currentComps = components(from: Date())
    let dateComps = components(from: date)
    return currentComps.0 == dateComps.0 && currentComps.1 == dateComps.1 && currentComps.2 == dateComps.2
}
//Download by www.codefans.net
private let solarTermInfo = [0,21208,42467,63836,85337,107014,128867,150921,173149,195551,218072,240693,263343,285989,308563,331033,353350,375494,397447,419210,440795,462224,483532,504758]

/// 计算{year}年的第{n}个节气为几日
///
/// - Parameter year: 公历年
/// - Parameter n: 从0开始
/// - Returns: 第{n}个节气所在的日期
func sTerm(year: Int, n: Int) -> Int {
    //计算有问题 例如2017.7.22 大暑
    let timestamp = Double(-2208549300000 as Int64) // UTC(1900, 0, 6, 2, 5, 0)
    let timeMillis = (31556925974.7 * Double(year - 1900)) + Double(solarTermInfo[n]) * 60000.0 + timestamp
    
    let date = Date(timeIntervalSince1970: timeMillis/1000.0)
    
    let comps = Manager.componentsForDate(date, calendar: gregorianCalendar)
    return comps.day!
}
