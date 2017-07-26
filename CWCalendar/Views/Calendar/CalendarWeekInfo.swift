//
//  CalendarWeekInfo.swift
//  CWCalendar
//
//  Created by william on 2017/7/25.
//  Copyright © 2017年 陈大威. All rights reserved.
//

import UIKit

class CalendarWeekInfo: NSObject {
    weak var monthInfo: CalendarMonthInfo!
    var dayInfos: [CalendarDayInfo]!
    var index: Int!
    
    var weekdaysIn: [Int : [Int]]?
    var weekdaysOut: [Int : [Int]]?
    
    init(monthInfo: CalendarMonthInfo, index: Int) {
        self.monthInfo = monthInfo
        self.index = index
        
        super.init()
        
        let weeksIn = self.monthInfo!.weeksIn!
        self.weekdaysIn = weeksIn[self.index!]
        
        if let weeksOut = self.monthInfo!.weeksOut {
            if (self.weekdaysIn?.count)! < 7 {
                if weeksOut.count > 1 {
                    let daysOut = 7 - self.weekdaysIn!.count
                    
                    var result: [Int : [Int]]?
                    for weekdaysOut in weeksOut {
                        if weekdaysOut.count == daysOut {
                            
                            let key = weekdaysOut.keys.first!
                            let value = weekdaysOut[key]![0]
                            if value > 20 {
                                if self.index == 0 {
                                    result = weekdaysOut
                                    break
                                }
                            } else if value < 10 {
                                if self.index == (dateManager.monthDateRange(self.monthInfo!.date!)
                                    .countOfWeeks) - 1 {
                                    result = weekdaysOut
                                    break
                                }
                            }
                        }
                    }
                    
                    self.weekdaysOut = result!
                } else {
                    self.weekdaysOut = weeksOut[0]
                }
                
            }
        }
        
        dayInfos = [CalendarDayInfo]()
        for i in 1...7 {
            let dayInfo = CalendarDayInfo(weekInfo: self, weekdayIndex: i)
            dayInfos.append(dayInfo)
        }
        
    }
    
}
