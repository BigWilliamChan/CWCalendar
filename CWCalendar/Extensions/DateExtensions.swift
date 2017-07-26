//
//  DateExtensions.swift
//  CWCalendar
//
//  Created by william on 2017/7/25.
//  Copyright © 2017年 陈大威. All rights reserved.
//

import Foundation
extension Date {
    
    var firstDayOfMonth: Date? {
        get{
            let calendar = Calendar.current
            var components = calendar.dateComponents([.year, .month, .day], from:self)
            components.day? = 1
            return calendar.date(from: components)
        }
    }
    
    var tomorrow: Date? {
        get{
            let calendar = Calendar.current
            var components = calendar.dateComponents([.year, .month, .day], from: self)
            components.day? += 1
            return calendar.date(from: components)
        }
    }
    
    var hour: Int? {
        let calendar  = Calendar.current
        var components = calendar.dateComponents([.hour], from: self)
        return components.hour
    }
    
    var year: Int? {
        let calendar  = Calendar.current
        var components = calendar.dateComponents([.year], from: self)
        return components.year
    }
    var month: Int? {
        let calendar  = Calendar.current
        var components = calendar.dateComponents([.month], from: self)
        return components.month
    }
    var day: Int? {
        let calendar  = Calendar.current
        var components = calendar.dateComponents([.day], from: self)
        return components.day
    }
    
    var yesterday: Date? {
        get{
            let calendar  = Calendar.current
            var components = calendar.dateComponents([.year, .month, .day], from: self)
            components.day? -= 1
            return calendar.date(from: components)
        }
    }
    
    var dayBegin: Date? {
        get{
            let calendar = Calendar.current
            var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
            components.hour? = 0
            components.minute? = 0
            components.second? = 0
            return calendar.date(from: components)
        }
    }
    
    var dayEnd: Date? {
        get{
            let calendar = Calendar.current
            var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
            components.hour?   = 23
            components.minute? = 59
            components.second? = 59
            return calendar.date(from: components)
        }
    }
    
    var weekday: Int {
        get{
            let calendar = Calendar.current
            var components = calendar.dateComponents([.weekday], from: self)
            return components.weekday!
        }
    }
    
    
    //离当前时间最近的下一个整时间点
    var dayReplace: Date? {
        get{
            let calendar = Calendar.current
            var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
            
            let hours   = components.hour
            let minutes = components.minute
            let seconds = components.second
            
            components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
            components.hour = hours
            components.minute = minutes
            components.second = seconds
            
            return calendar.date(from: components)
        }
    }
    
    func UTCNumber() -> (Int, Int, Int) {
        let calendar = gregorianCalendar
        var components = calendar.dateComponents([.year, .month, .day], from: self)
        return (components.year!, components.month!, components.day!)
    }
    
    func addingYears(_ years: Int, calendar: Calendar = Calendar.current) -> Date? {
        var components = DateComponents.init()
        components.year? = years
        return calendar.date(byAdding: components, to: self)
    }
    
    func addingMonths(_ months: Int, calendar: Calendar = Calendar.current) -> Date? {
        var components = DateComponents.init()
        components.month? = months
        return calendar.date(byAdding: components, to: self)
    }
    func addingDays(_ days: Int, calendar: Calendar = Calendar.current) -> Date? {
        var components = DateComponents.init()
        components.day? = days
        return calendar.date(byAdding: components, to: self)
    }
    
    init?(year: Int, month: Int, day: Int,calendar: Calendar = Calendar.current) {
        var components = calendar.dateComponents([.year, .month, .day], from: Date())
        components.year = year
        components.month = month
        components.day = day
        self = calendar.date(from: components)!
    }
    
}
extension Date {
    //对应时间星座
    static let constellDict  = ["白羊座":(3.21,4.19),
                                "金牛座":(4.20,5.20),
                                "双子座":(5.21,6.21),
                                "巨蟹座":(6.22,7.22),
                                "狮子座":(7.23,8.22),
                                "处女座":(8.23,9.22),
                                "天秤座":(9.23,10.23),
                                "天蝎座":(10.24,11.21),
                                "射手座":(11.22,12.21),
                                "摩羯座":(12.22,1.19),
                                "水瓶座":(1.20,2.18),
                                "双鱼座":(2.19,3.20)]
    var constellation: String {
        
        var myCon:String = ""
        
        let (_, month, day) = components(from: self);
        let time:Double = Double(month) + Double(day)/100.0
        for (key, (start,end)) in Date.constellDict {
            
            if start <= time && time <= end {
                myCon = key
                break
            }
        }
        if myCon.isEmpty {
            myCon = "摩羯座"
        }
        return myCon
    }
}

