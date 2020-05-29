//
//  SetReminderViewController.swift
//  ThisWeek
//
//  Created by Emanuel on 28/05/2020.
//  Copyright © 2020 Emanuel. All rights reserved.
//

import UIKit

protocol SetReminderViewControllerDelegate : class {
    func addReminder(_ sender : SetReminderViewController)
    func deleteReminder(_ sender : SetReminderViewController)
}

class SetReminderViewController: UIViewController {
    
    var reminderDay : Date = Date()
    var deleteButtonNeeded = true
    
    //  MARK:-  Delegation
    weak var delegate : SetReminderViewControllerDelegate?

    //  MARK:- ViewController Lifecycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let fittedSize = topLevelStack?.sizeThatFits(UIView.layoutFittingCompressedSize){
            preferredContentSize = CGSize(width: fittedSize.width, height: fittedSize.height )
        }
    }
    
//    MARK:- Actions
    
    @IBAction func cancel(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func set(_ sender: UIButton) {
        reminderDay = reminderDate.date
        self.delegate?.addReminder(self)
        presentingViewController?.dismiss(animated: true)
        
    }
    
    @IBAction func deleActualReminder(_ sender: UIButton) {
        self.delegate?.deleteReminder(self)
        presentingViewController?.dismiss(animated: true)
    }
    
    //    MARK: - Outlets
    @IBOutlet weak var reminderDate: UIDatePicker!
    
    @IBOutlet weak var topLevelStack: UIStackView!
    
    @IBOutlet weak var cancelButton: UIButton!{
        didSet{
            cancelButton.setTitle(ThisWeekViewController.Defaults.cancelButtonText, for: .normal)
        }
    }
    
    @IBOutlet weak var setButton: UIButton!{
        didSet{
            setButton.setTitle(ThisWeekViewController.Defaults.setButtonText, for: .normal)
        }
    }
    @IBOutlet weak var pickTimeLabel: UILabel!{
        didSet{
            pickTimeLabel.text = ThisWeekViewController.Defaults.pickTimeText
        }
    }
    @IBOutlet weak var deleteReminderButton: UIButton!{
        didSet{
            deleteReminderButton.setTitle(ThisWeekViewController.Defaults.deleteButtonText, for: .highlighted)
            if deleteButtonNeeded{
                deleteReminderButton.isHidden = false
            }else{
                deleteReminderButton.isHidden = true
            }
        }
    }
}
