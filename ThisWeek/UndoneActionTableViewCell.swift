//
//  UndoneActionTableViewCell.swift
//  ThisWeek
//
//  Created by Emanuel on 27/05/2020.
//  Copyright © 2020 Emanuel. All rights reserved.
//

import UIKit

protocol UndoneActionTableViewCellDelegate : class {
    func endEditingTask(_ sender : UndoneActionTableViewCell)
}

class UndoneActionTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    //    MARK: - Delegation
    weak var delegate : UndoneActionTableViewCellDelegate?

//    MARK:- Outlets & Actions
    
    var buttonString :  String = ""{
        didSet{
            setAttibutedStringtoButton(string: buttonString)
        }
    }
    
    private func setAttibutedStringtoButton( string: String){
        addNewReminderButton.setTitle(string, for: .normal)
        let attrs = [
            NSAttributedString.Key.underlineStyle : 0]
        let attributedString = NSMutableAttributedString(string:"")

        let buttonTitleStr = NSMutableAttributedString(string: string, attributes:attrs)
        attributedString.append(buttonTitleStr)
        addNewReminderButton.setAttributedTitle(attributedString, for: .normal)

    }
    
    @IBOutlet weak var addNewReminderButton: UIButton!
    
    @IBOutlet weak var taskTextField: UITextField!{
        didSet{
            taskTextField.delegate = self
            taskTextField.isUserInteractionEnabled = false
            taskTextField.autocapitalizationType = .sentences
            taskTextField.autocorrectionType = .yes
            taskTextField.clearButtonMode = .whileEditing
        }
    }
   
    var addReminderButtonHandler : (()->Void)?
    
    @IBAction func addReminderButton(_ sender: UIButton) {
        addReminderButtonHandler?()
    }
    
//    MARK:- UITextFieldDelegate
    
    func startEditing(){
        taskTextField.isUserInteractionEnabled = true
        taskTextField.becomeFirstResponder()
    }
    
    var resignationHandler : (()->Void)?
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        resignationHandler?()
        delegate?.endEditingTask(self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        taskTextField.isUserInteractionEnabled = false
        taskTextField.resignFirstResponder()
        return true
    }
    
//    MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
