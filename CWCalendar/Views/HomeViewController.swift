//
//  HomeViewController.swift
//  CWCalendar
//
//  Created by william on 2017/7/25.
//  Copyright © 2017年 陈大威. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var calendarCell: CalendarCell!
    var calendarView: CalendarView {
        return calendarCell.calendarView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetup()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    private func tableViewSetup() {
        calendarCell = tableView.dequeueReusableCell(withIdentifier: "CalendarCell") as! CalendarCell
        calendarCell.calendarView.delegate = self
    }
   

}

// MARK: CalendarViewDelegate
extension HomeViewController: CalendarViewDelegate {
    func calendarViewHeightDidChange() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func calendarViewDidSelectDate(_ date: CalendarDate) {
//        selectedDay.value = date
    }
    
    func calendarViewFinishSelectDate(_ date: CalendarDate) {
//        finallySelectedDay.value = date
    }
}
