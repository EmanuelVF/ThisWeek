//
//  OnboardingViewController.swift
//  ThisWeek
//
//  Created by Emanuel on 02/06/2020.
//  Copyright © 2020 Emanuel. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    
    //MARK:- Functions
    
    @IBAction func done(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: ThisWeekViewController.Defaults.UserDefaultsOnBoardingDoneKey)
        performSegue(withIdentifier: ThisWeekViewController.Defaults.IDFromOnboardingToMain, sender: self)
    }
    
    //MARK:- Outlets
    
    @IBOutlet weak var welcomeLabel: UILabel!{
        didSet{
            welcomeLabel.text = ThisWeekViewController.Defaults.welcomeLabelText
        }
    }
    
    @IBOutlet weak var subTitleLabel: UILabel!{
        didSet{
            subTitleLabel.text = ThisWeekViewController.Defaults.subTitleLabelText
        }
    }
    
    @IBOutlet weak var planLabel: UILabel!{
        didSet{
            planLabel.text = ThisWeekViewController.Defaults.planLabelText
        }
    }
    
    @IBOutlet weak var setLabel: UILabel!{
        didSet{
            setLabel.text = ThisWeekViewController.Defaults.setLabelText
        }
    }
    
    @IBOutlet weak var outlineLabel: UILabel!{
        didSet{
            outlineLabel.text = ThisWeekViewController.Defaults.outlineLabelText
        }
    }
    
    @IBOutlet weak var getStartedButton: UIButton!{
        didSet{
            getStartedButton.setTitle(ThisWeekViewController.Defaults.getStartedButtonText, for: .normal)
        }
    }
}
