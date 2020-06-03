//
//  SetDateViewController.swift
//  ThisWeek
//
//  Created by Emanuel on 03/06/2020.
//  Copyright © 2020 Emanuel. All rights reserved.
//

import UIKit

protocol SetDateViewControllerDelegate : class {
    func setAFutureDay(_ sender : SetDateViewController)
    func deleteAFutureDay(_ sender : SetDateViewController)
}

class SetDateViewController: UIViewController {
    
    var dayToRemember : Date?
    var newDayToRemember : Date?
    var editingMode : Bool?

//    MARK: - ViewController LifeCycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let fittedSize = mainStack?.sizeThatFits(UIView.layoutFittingCompressedSize){
            preferredContentSize = CGSize(width: fittedSize.width * ThisWeekViewController.Defaults.pickerSizeFactor, height: fittedSize.height * ThisWeekViewController.Defaults.pickerSizeFactor)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if dayToRemember != nil {
            pickerDate.setDate( dayToRemember!, animated: true)
        }else{
            pickerDate.setDate(Date().addingTimeInterval(TimeInterval(8*ThisWeek.Defaults.oneDay)),animated: true)
        }
    }

    //  MARK:-  Delegation
    weak var delegate : SetDateViewControllerDelegate?
    
    //    MARK:- Actions
    
    
    @IBAction func leftButtonPressed(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func rightButtonPressed(_ sender: UIButton) {
        if editingMode! == false{
            rightButton.setTitle(ThisWeekViewController.Defaults.rightButtonTextChoose, for: .normal)
            pickerDate.isUserInteractionEnabled = true
            editingMode = true
            titleLabel.text = ThisWeekViewController.Defaults.titleTextChoose
        }else{
            newDayToRemember = pickerDate.date
            self.delegate?.setAFutureDay(self)
            presentingViewController?.dismiss(animated: true)
        }
    }
    
    @IBAction func lastButtonPressed(_ sender: UIButton) {
        self.delegate?.deleteAFutureDay(self)
        presentingViewController?.dismiss(animated: true)
    }
    
    
    //    MARK: - Outlets
    @IBOutlet weak var mainStack: UIStackView!
    
    @IBOutlet weak var titleLabel: UILabel!{
        didSet{
            if dayToRemember != nil{
                titleLabel.text = ThisWeekViewController.Defaults.titleTextInfo
            }else{
                titleLabel.text = ThisWeekViewController.Defaults.titleTextChoose
            }
        }
    }
    
    @IBOutlet weak var pickerDate: UIDatePicker!{
        didSet{
            pickerDate.minimumDate = Date().addingTimeInterval(TimeInterval(ThisWeekViewController.Defaults.oneWeek))
            pickerDate.maximumDate = nil
            if dayToRemember != nil{
                pickerDate.isUserInteractionEnabled = false
                editingMode = false
            }else{
                pickerDate.isUserInteractionEnabled = true
                editingMode = true
            }
        }
    }
    
    @IBOutlet weak var rightButton: UIButton!{
        didSet{
            if dayToRemember != nil{
                rightButton.setTitle(ThisWeekViewController.Defaults.rightButtonTextEdit, for: .normal)
            }else{
                rightButton.setTitle(ThisWeekViewController.Defaults.rightButtonTextChoose, for: .normal)
            }
        }
    }
    
    
    @IBOutlet weak var leftButton: UIButton!{
        didSet{
            leftButton.setTitle(ThisWeekViewController.Defaults.leftButtonTextCancel, for: .normal)
        }
    }
    
    @IBOutlet weak var lastButton: UIButton!{
        didSet{
            if dayToRemember != nil{
                lastButton.setTitle(ThisWeekViewController.Defaults.lastButtonTextDelete, for: .normal)
                lastButton.isHidden = false
            }else{
                lastButton.isHidden = true
            }
        }
    }
    
    
}
