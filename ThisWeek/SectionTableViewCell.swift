//
//  SectionTableViewCell.swift
//  ThisWeek
//
//  Created by Emanuel on 26/05/2020.
//  Copyright © 2020 Emanuel. All rights reserved.
//

import UIKit

class SectionTableViewCell: UITableViewCell {
    
    var addingTask = false

    @IBOutlet weak var titleLabel: UILabel!
    

    @IBAction func addAction(_ sender: UIButton) {
        addingTask = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
