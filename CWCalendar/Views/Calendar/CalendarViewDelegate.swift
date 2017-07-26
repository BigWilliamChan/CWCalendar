//
//  CalendarViewDelegate.swift
//  CWCalendar
//
//  Created by william on 2017/7/25.
//  Copyright © 2017年 陈大威. All rights reserved.
//

import UIKit

@objc protocol CalendarViewDelegate {
    @objc optional func calendarViewHeightDidChange()
    @objc optional func calendarViewDidSelectDate(_ date: CalendarDate)
    @objc optional func calendarViewFinishSelectDate(_ date: CalendarDate)
}
