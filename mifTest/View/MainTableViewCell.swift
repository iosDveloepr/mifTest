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
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
