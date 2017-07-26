//
//  CalendarCell.swift
//  CWCalendar
//
//  Created by william on 2017/7/25.
//  Copyright © 2017年 陈大威. All rights reserved.
//

import UIKit

class CalendarCell: UITableViewCell {

    @IBOutlet weak var calendarView: CalendarView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
