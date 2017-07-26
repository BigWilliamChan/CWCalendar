//
//  CalendarContentViewController.swift
//  CWCalendar
//
//  Created by william on 2017/7/25.
//  Copyright © 2017年 陈大威. All rights reserved.
//

import UIKit

class CalendarContentViewController: UIViewController {
    
    unowned let calendarView: CalendarView
    let scrollView: UIScrollView
    
    var leftMonthView: CalendarMonthView!
    var centerMonthView: CalendarMonthView!
    var rightMonthView: CalendarMonthView!
    
    var currentMonthInfo: CalendarMonthInfo!
    
    var selectedDate: CalendarDate! {
        didSet {
            calendarView.delegate?.calendarViewDidSelectDate?(selectedDate)
        }
    }
    
    var bounds: CGRect {
        return scrollView.bounds
    }
    
    fileprivate var moveTimer: Timer!
    
    init(calendarView: CalendarView, frame: CGRect) {
        self.calendarView = calendarView
        scrollView = UIScrollView(frame: frame)
        
        super.init(nibName: nil, bundle: nil)
        
        scrollView.contentSize = CGSize(width: frame.width * 3, height: frame.height)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.layer.masksToBounds = true
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.backgroundColor = UIColor.clear
        
        createMonthViews()
        
        layoutMonthViews()
        
        loadMonthInfo(calendarView.today)
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: .UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: .UIApplicationSignificantTimeChange, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIApplicationSignificantTimeChange, object: nil)
    }
}

extension CalendarContentViewController {
    func createMonthViews() {
        leftMonthView = CalendarMonthView()
        scrollView.addSubview(leftMonthView)
        
        centerMonthView = CalendarMonthView()
        scrollView.addSubview(centerMonthView)
        
        rightMonthView = CalendarMonthView()
        scrollView.addSubview(rightMonthView)
        
        [leftMonthView, centerMonthView, rightMonthView].forEach {
            
            $0?.mapDayViews { (dayView) in
                dayView.addTarget(self, action: #selector(self.didClickDayView), for: .touchUpInside)
            }
        }
        
    }
    
    func layoutMonthViews() {
        leftMonthView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        centerMonthView.frame = CGRect(x: bounds.width, y: 0, width: bounds.width, height: bounds.height)
        rightMonthView.frame = CGRect(x: bounds.width * 2, y: 0, width: bounds.width, height: bounds.height)
    }
    
    func loadMonthInfo(_ date: Foundation.Date) {
        currentMonthInfo = CalendarMonthInfo(date: date)
        centerMonthView.monthInfo = currentMonthInfo
        
        rightMonthView.monthInfo = getFollowingMonth(date)
        leftMonthView.monthInfo = getPreviousMonth(date)
        
        scrollView.setContentOffset(CGPoint(x: bounds.width, y: 0), animated: false)
        
        selectedDate = CalendarDate(date: date)
    }
    
    func togglePresentedDate(_ date: Foundation.Date) {
        
        loadMonthInfo(date)
        
        centerMonthView.mapDayViews({ (dayView) in
            if let date = dayView.dayInfo?.date, matchedDays(selectedDate, date) {
                calendarView.selectDayView(dayView, animation: true, isHidden: dayView.isToday)
            }
        })
    }
    
    func refresh() {
        let date = selectedDate.convertedDate()!
        loadMonthInfo(date)
    }
}

//MARK: - Month Manager
extension CalendarContentViewController {
    func getFollowingMonth(_ date: Foundation.Date) -> CalendarMonthInfo {
        let firstDate = dateManager.monthDateRange(date).monthStartDate
        var components = Manager.componentsForDate(firstDate)
        
        components.month! += 1
        
        let newDate = Calendar.current.date(from: components)!
        let monthInfo = CalendarMonthInfo(date: newDate)
        return monthInfo
    }
    
    func getPreviousMonth(_ date: Foundation.Date) -> CalendarMonthInfo {
        let firstDate = dateManager.monthDateRange(date).monthStartDate
        var components = Manager.componentsForDate(firstDate)
        
        components.month! -= 1
        
        let newDate = Calendar.current.date(from: components)!
        let monthInfo = CalendarMonthInfo(date: newDate)
        return monthInfo
    }
}

//MARK: - UIScrollViewDelegate
extension CalendarContentViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        invalidateTimer()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if !currentMonthInfo.allowScrollToPreviousMonth, scrollView.contentOffset.x < bounds.width {
            scrollView.setContentOffset(CGPoint(x: bounds.width, y: 0), animated: false)
            return
        }
        
        if !currentMonthInfo.allowScrollToNextMonth, scrollView.contentOffset.x > bounds.width {
            scrollView.setContentOffset(CGPoint(x: bounds.width, y: 0), animated: false)
            return
        }
        
        if scrollView.contentOffset.x == 0 {
            
            currentMonthInfo = leftMonthView.monthInfo
            
        } else if scrollView.contentOffset.x == bounds.width * 2 {
            
            currentMonthInfo = rightMonthView.monthInfo
            
        } else {
            return
        }
        
        let date = currentMonthInfo.date
        
        leftMonthView.monthInfo = getPreviousMonth(date!)
        centerMonthView.monthInfo = currentMonthInfo
        rightMonthView.monthInfo = getFollowingMonth(date!)
        
        scrollView.contentOffset = CGPoint(x: bounds.width, y: 0)
        
        updateSelection()
        
        moveTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(stopDragging), userInfo: nil, repeats: false)
    }
    
    //MARK: - Helper
    
    @objc func stopDragging() {
        invalidateTimer()
        updateLayoutIfNeeded()
        
        calendarView.delegate?.calendarViewFinishSelectDate?(selectedDate)
    }
    
    func invalidateTimer() {
        if moveTimer != nil {
            moveTimer.invalidate()
            moveTimer = nil
        }
    }
}

//MARK: - Layout
extension CalendarContentViewController {
    func updateHeight(_ height: CGFloat) {
        for constraintIn in calendarView.constraints where
            constraintIn.firstAttribute == NSLayoutAttribute.height {
                constraintIn.constant = height
                break
        }
    }
    
    func updateLayoutIfNeeded() {
        let height = centerMonthView.potentialSize.height
        if calendarView.height != height {
            updateHeight(height)
            calendarView.height = height
            calendarView.delegate?.calendarViewHeightDidChange?()
        }
    }
}

//MARK: - Select Action
extension CalendarContentViewController {
    @objc func didClickDayView(_ dayView: CalendarDayView) {
        guard let date = dayView.date else {
            return
        }
        
        selectedDate = date
        
        calendarView.selectDayView(dayView, animation: true, isHidden: dayView.isToday)
        
        if dayView.dayInfo!.isOut {
            performedDayViewSelection(dayView.dayInfo!)
        } else {
            calendarView.delegate?.calendarViewFinishSelectDate?(selectedDate)
        }
    }
    
    func performedDayViewSelection(_ dayInfo: CalendarDayInfo) {
        if dayInfo.date.day > 20 {
            //翻到上一个月
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        } else {
            //翻到下一个月
            scrollView.setContentOffset(CGPoint(x: bounds.width * 2, y: 0), animated: true)
        }
        
        Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(timerAction), userInfo: nil, repeats: false)
    }
    
    @objc func timerAction() {
        scrollViewDidScroll(scrollView)
    }
    
    //翻页时自动选择
    func updateSelection() {
        let currentDate = CalendarDate(date: currentMonthInfo.date)
        if !matchedMonths(selectedDate, currentDate) {
            //手动滑动时自动选择1号或者今天
            let today = CalendarDate(date: Date())
            if matchedMonths(today, currentDate) {
                selectedDate = today
            } else {
                selectedDate = CalendarDate(date: dateManager
                    .monthDateRange(currentMonthInfo.date).monthStartDate)
            }
        }
        
        centerMonthView.mapDayViews({ (dayView) in
            if let date = dayView.dayInfo?.date, matchedDays(selectedDate, date) {
                calendarView.selectDayView(dayView, animation: true, isHidden: dayView.isToday)
            }
        })
    }
}

extension CalendarContentViewController {
    @objc func applicationDidBecomeActive() {
        let currentDate = Date()
        if !matchedDays(CalendarDate(date: currentDate), CalendarDate(date: calendarView.today)) {
            calendarView.today = currentDate
            togglePresentedDate(currentDate)
            updateLayoutIfNeeded()
        }
    }
}

