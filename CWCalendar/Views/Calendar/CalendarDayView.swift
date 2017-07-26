//
//  CalendarDayView.swift
//  CWCalendar
//
//  Created by william on 2017/7/25.
//  Copyright © 2017年 陈大威. All rights reserved.
//

import UIKit

class CalendarDayView: UIControl {
    fileprivate var dayLabel: UILabel!
    fileprivate var todayIcon: UIView!
    fileprivate var statusIcon: UIImageView!
    
    
    var date: CalendarDate? {
        guard let dayInfo = dayInfo else {
            return nil
        }
        return dayInfo.date
    }
    
    var isToday: Bool {
        guard let dayInfo = dayInfo else {
            return false
        }
        
        return dayInfo.date.isToday
    }
    
    var dayInfo: CalendarDayInfo? {
        didSet {
            guard let dayInfo = dayInfo, dayInfo.date != oldValue?.date else {
                return
            }
            dayLabel.text = String(dayInfo.date.day)
  
            dayLabel.textColor = CalendarViewAppearance.dayLabelColor(by: dayInfo.weekday, status: dayInfo.dayStatus, today: dayInfo.date.isToday)
            
            if dayInfo.date.isToday {
                todayIcon.isHidden = false
                todayIcon.alpha = dayInfo.isOut ? 0.45 : 1.0
            } else {
                todayIcon.isHidden = true
            }
            
            isUserInteractionEnabled = (dayInfo.dayStatus != .disabled)
        }
    }
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = UIColor.clear
        
        dayLabel = UILabel()
        dayLabel.textAlignment = .center
        dayLabel.font = CalendarViewAppearance.dayLabelFont
        addSubview(dayLabel)
        
        todayIcon = UIView()
        todayIcon.backgroundColor = AppColor.today
        todayIcon.isUserInteractionEnabled = false;
        todayIcon.layer.cornerRadius = 48/2
        todayIcon.layer.shadowColor = AppColor.today.cgColor
        todayIcon.layer.shadowOpacity = 0.3
        todayIcon.layer.shadowOffset = CGSize(width: 0, height: 5)
        todayIcon.isHidden = true
        insertSubview(todayIcon, at: 0)
        
        statusIcon = UIImageView()
        statusIcon.isHidden = true
        insertSubview(statusIcon, aboveSubview: todayIcon)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dayLabel?.frame = CGRect(x: 0.0, y: 0, width: bounds.width, height: bounds.height)
        
        
        todayIcon.frame = CGRect(x: (bounds.width - 48)/2.0, y: (bounds.height - 48)/2.0, width: 48, height: 48)
        
        
        let side1 = CGFloat(14)
        statusIcon.frame = CGRect(x: bounds.width - side1 - 3, y: 4, width: side1, height: side1)
        
        super.layoutSubviews()
    }
}
