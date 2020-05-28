//
//  UndoneActionTableViewCell.swift
//  ThisWeek
//
//  Created by Emanuel on 27/05/2020.
//  Copyright © 2020 Emanuel. All rights reserved.
//

import UIKit

class UndoneActionTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var taskTextField: UITextField!{
        didSet{
            taskTextField.delegate = self
            taskTextField.isUserInteractionEnabled = false
        }
    }
   
    var addReminderButtonHandler : (()->Void)?
    
    @IBAction func addReminderButton(_ sender: UIButton) {
        addReminderButtonHandler?()
    }
    
    
    func startEditing(){
        taskTextField.isUserInteractionEnabled = true
        taskTextField.becomeFirstResponder()
    }
    
    var resignationHandler : (()->Void)?
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        resignationHandler?()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        taskTextField.isUserInteractionEnabled = false
        taskTextField.resignFirstResponder()
        return true
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
