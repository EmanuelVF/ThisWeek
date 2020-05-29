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
}

class SetReminderViewController: UIViewController {
    
    var reminderTitle : String = ""
    var reminderDay : Date = Date()
    
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
}
