//
//  CalendarMonthInfo.swift
//  CWCalendar
//
//  Created by william on 2017/7/25.
//  Copyright © 2017年 陈大威. All rights reserved.
//

import Foundation

class CalendarMonthInfo: NSObject {
    var date: Foundation.Date!
    var numberOfWeeks: Int!
    var weekInfos: [CalendarWeekInfo]!
    
    var weeksIn: [[Int : [Int]]]?
    var weeksOut: [[Int : [Int]]]?
    
    var allowScrollToPreviousMonth = true
    var allowScrollToNextMonth = true
    
    init(date: Foundation.Date) {
        self.date = date
        
        numberOfWeeks = dateManager.monthDateRange(self.date).countOfWeeks
        self.weeksIn = dateManager.weeksWithWeekdaysForMonthDate(self.date).weeksIn
        self.weeksOut = dateManager.weeksWithWeekdaysForMonthDate(self.date).weeksOut
        
        super.init()
        
        weekInfos = [CalendarWeekInfo]()
        for i in 0 ..< numberOfWeeks {
            let weekInfo = CalendarWeekInfo(monthInfo: self, index: i)
            weekInfos.append(weekInfo)
        }
    }
}
