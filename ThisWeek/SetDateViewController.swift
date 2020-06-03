//
//  SetDateViewController.swift
//  ThisWeek
//
//  Created by Emanuel on 03/06/2020.
//  Copyright © 2020 Emanuel. All rights reserved.
//

import UIKit

class SetDateViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var mainStack: UIStackView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var pickerDate: UIDatePicker!
    
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    
    @IBOutlet weak var lastButton: UIButton!
    
    
    @IBAction func leftButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func rightButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func lastButtonPressed(_ sender: UIButton) {
    }
}
