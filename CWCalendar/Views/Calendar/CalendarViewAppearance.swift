//
//  CalendarViewAppearance.swift
//  CWCalendar
//
//  Created by william on 2017/7/25.
//  Copyright © 2017年 陈大威. All rights reserved.
//

import UIKit

struct CalendarViewAppearance {
    
    static var dayLabelFont: UIFont {
        return UIFont.systemFont(ofSize: 20, weight: UIFontWeightThin)
    }
    
    static func dayLabelColor(by weekDay: CalendarWeekday, status: DayStatus, today: Bool) -> UIColor {
        if today {
            return AppColor.white
        }else{
            switch (weekDay, status) {
                //weeks color when out of month 不在本月的星期，文案颜色
            case (.sunday, .out), (.saturday, .out): return AppColor.orange.withAlphaComponent(0.45)
                //weeks color when in month 在本月的星期，文案颜色
            case (.sunday, .in), (.saturday, .in): return AppColor.orange
                //disabled color 不是本月的文案颜色
            case (_, .out), (_, .disabled): return AppColor.black.withAlphaComponent(0.45)
                //normal color 正常工作日期文案颜色
            default: return AppColor.black
            }
        }
        
    }
    
    
}
