//
//  CalendarWeekView.swift
//  CWCalendar
//
//  Created by william on 2017/7/25.
//  Copyright © 2017年 陈大威. All rights reserved.
//

import UIKit

class CalendarWeekView: UIView {
    
    var dayViews: [CalendarDayView]!
    
    var weekInfo: CalendarWeekInfo? {
        didSet {
            guard let weekInfo = weekInfo else {
                return
            }
            
            for (dayInfo, dayView) in zip(weekInfo.dayInfos, dayViews) {
                dayView.dayInfo = dayInfo
            }
        }
    }
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = UIColor.clear
        
        createDayViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutDayViews()
        
        super.layoutSubviews()
    }
    
    func mapDayViews(_ body: (CalendarDayView) -> ()) {
        if let dayViews = dayViews {
            for dayView in dayViews {
                body(dayView)
            }
        }
    }
}

// MARK: - Content fill & reload
extension CalendarWeekView {
    func createDayViews() {
        dayViews = [CalendarDayView]()
        for _ in 1...7 {
            let dayView = CalendarDayView()
            dayViews.append(dayView)
            addSubview(dayView)
        }
    }
    
    func layoutDayViews() {
        let height = bounds.height
        let width = bounds.width / 7.0
        for (index, dayView) in dayViews.enumerated() {
            let x = CGFloat(index) * CGFloat(width)
            dayView.frame = CGRect(x: x, y: 0, width: width, height: height)
        }
    }
}

