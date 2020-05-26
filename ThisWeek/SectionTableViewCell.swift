//
//  SectionTableViewCell.swift
//  ThisWeek
//
//  Created by Emanuel on 26/05/2020.
//  Copyright © 2020 Emanuel. All rights reserved.
//

import UIKit

protocol SectionTableViewCellDelegate : class {
    func addOneTask(_ sender : SectionTableViewCell)
}

class SectionTableViewCell: UITableViewCell {
    
//    MARK: - Delegation
    weak var delegate : SectionTableViewCellDelegate?
    
    var addingTask = false

    @IBOutlet weak var titleLabel: UILabel!
    

    @IBAction func addAction(_ sender: UIButton) {
        print("entre")
        addingTask = true
        self.delegate?.addOneTask(self)
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
