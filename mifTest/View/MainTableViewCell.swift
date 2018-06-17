//
//  MainTableViewCell.swift
//  mifTest
//
//  Created by Anton Yermakov on 11.06.2018.
//  Copyright © 2018 Anton Yermakov. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var reminder: Reminder?{
        didSet{
            titleLabel.text = reminder?.title
            messageLabel.text = reminder?.message
            
            if let date = reminder?.date{
                dateLabel.text = stringFromDate(date: date)
            }
        }
    }
    
    private func stringFromDate(date: Date) -> String {
        let formater = DateFormatter()
        formater.dateStyle = .short
        formater.timeStyle = .short
        let locale = Locale.current
        formater.locale = locale
        return formater.string(from: date)
    }
    

}
