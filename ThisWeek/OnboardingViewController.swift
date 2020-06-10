//
//  OnboardingViewController.swift
//  ThisWeek
//
//  Created by Emanuel on 02/06/2020.
//  Copyright © 2020 Emanuel. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBAction func done(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: ThisWeekViewController.Defaults.UserDefaultsOnBoardingDoneKey)
        performSegue(withIdentifier: ThisWeekViewController.Defaults.IDFromOnboardingToMain, sender: self)
    }
}
