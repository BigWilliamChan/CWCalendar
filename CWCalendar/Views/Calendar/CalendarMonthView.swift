//
//  CalendarMonthView.swift
//  CWCalendar
//
//  Created by william on 2017/7/25.
//  Copyright © 2017年 陈大威. All rights reserved.
//

import UIKit

class CalendarMonthView: UIView {
    var weekViews: [CalendarWeekView]!
    
    var monthInfo: CalendarMonthInfo? {
        didSet {
            guard let monthInfo = monthInfo else {
                return
            }
            
            for (weekInfo, weekView) in zip(monthInfo.weekInfos, weekViews) {
                weekView.weekInfo = weekInfo
            }
            
            showOrHideLastWeek()
            
        }
    }
    
    var potentialSize: CGSize {
        if let monthInfo = monthInfo {
            return CGSize(width: bounds.width,
                          height: CGFloat(monthInfo.numberOfWeeks) * weekViews[0].bounds.height)
        } else {
            return CGSize(width: bounds.width, height: CGFloat(6) * weekViews[0].bounds.height)
        }
    }
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = UIColor.clear
        
        createWeekViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutWeekViews()
        
        super.layoutSubviews()
    }
    
    func mapDayViews(_ body: (CalendarDayView) -> ()) {
        for weekView in weekViews {
            for dayView in weekView.dayViews {
                body(dayView)
            }
        }
    }
    
    func showOrHideLastWeek() {
        guard let monthInfo = monthInfo else {
            return
        }
        
        let lastWeekView = weekViews.last!
        if monthInfo.numberOfWeeks < 6 {
            lastWeekView.isHidden = true
            lastWeekView.mapDayViews({ (dayView) in
                dayView.dayInfo = nil
            })
        } else {
            lastWeekView.isHidden = false
        }
    }
}

extension CalendarMonthView {
    func createWeekViews() {
        weekViews = [CalendarWeekView]()
        for _ in 1...6 {
            let weekView = CalendarWeekView()
            weekViews.append(weekView)
            
            addSubview(weekView)
        }
    }
    
    func layoutWeekViews() {
        let height = bounds.height / 6.0 //总共都设置成6行，在5行时，hidden一行
        let width = bounds.width
        
        for (index, weekView) in weekViews.enumerated() {
            let y = CGFloat(index) * height
            weekView.frame = CGRect(x: 0, y: y, width: width, height: height)
        }
    }
}
