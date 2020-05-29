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
            addActionButton.setTitle("+", for: .normal)
            let attrs = [
                NSAttributedString.Key.underlineStyle : 0]
            let attributedString = NSMutableAttributedString(string:"")

            let buttonTitleStr = NSMutableAttributedString(string:"⊕", attributes:attrs)
            attributedString.append(buttonTitleStr)
            addActionButton.setAttributedTitle(attributedString, for: .normal)
        }
    }
    
    @IBAction func addAction(_ sender: UIButton) {
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
