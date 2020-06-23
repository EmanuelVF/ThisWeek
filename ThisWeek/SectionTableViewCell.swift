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

    //    MARK: - Outlets and Actions
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var addActionButton: UIButton!{
        didSet{
            let attrs = [NSAttributedString.Key.underlineStyle : 0,
                         NSAttributedString.Key.foregroundColor : UIColor.white] as [NSAttributedString.Key : Any]
            let attributedString = NSMutableAttributedString(string:ThisWeekViewController.Defaults.addingButtonTitle, attributes:attrs)

            addActionButton.setAttributedTitle(attributedString, for: .normal)
        }
    }
    
    @IBAction func addAction(_ sender: UIButton) {
        self.delegate?.addOneTask(self)
    }

}
