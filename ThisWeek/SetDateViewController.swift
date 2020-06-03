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

    //  MARK:-  Delegation
    weak var delegate : SetDateViewControllerDelegate?
    
    //    MARK:- Actions
    
    
    @IBAction func leftButtonPressed(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func rightButtonPressed(_ sender: UIButton) {
        if editingMode! == false{
            rightButton.setTitle("Elegir", for: .normal)
            pickerDate.isUserInteractionEnabled = true
            editingMode = true
            titleLabel.text = "Elegi el dia puto"
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
                titleLabel.text = "Queres saber tu dia guachin?"
            }else{
                titleLabel.text = "Elegi el dia puto"
            }
        }
    }
    
    @IBOutlet weak var pickerDate: UIDatePicker!{
        didSet{
            if dayToRemember != nil{
                pickerDate.date = Date().addingTimeInterval(TimeInterval(8*ThisWeek.Defaults.oneDay))
                pickerDate.isUserInteractionEnabled = true
                editingMode = true
            }else{
                pickerDate.date = dayToRemember!
                pickerDate.isUserInteractionEnabled = false
                editingMode = false
            }
        }
    }
    
    @IBOutlet weak var rightButton: UIButton!{
        didSet{
            if dayToRemember != nil{
                rightButton.setTitle("Editar", for: .normal)
            }else{
                rightButton.setTitle("Elegir", for: .normal)
            }
        }
    }
    
    
    @IBOutlet weak var leftButton: UIButton!{
        didSet{
            leftButton.setTitle("Cancelar", for: .normal)
        }
    }
    
    @IBOutlet weak var lastButton: UIButton!{
        didSet{
            if dayToRemember != nil{
                lastButton.setTitle("Eliminar Recordatorio", for: .normal)
                lastButton.isHidden = false
            }else{
                lastButton.isHidden = true
            }
        }
    }
    
    
}
