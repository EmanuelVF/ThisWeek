//
//  ViewController.swift
//  ThisWeek
//
//  Created by Emanuel on 26/05/2020.
//  Copyright © 2020 Emanuel. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
//    MARK: - Model
    private var thisWeek = ThisWeek(numberOfDays: ThisWeek.Defaults.numberOfDays)
    

//    MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        thisWeek.addToDo(activity: Activity(name: "Planchar", priority: 0), at: 0)
        thisWeek.addToDo(activity: Activity(name: "Ir a comprar", priority: 0), at: 0)
        thisWeek.addToDo(activity: Activity(name: "Reunion con Pepe", priority: 0), at: 1)
        thisWeek.addToDo(activity: Activity(name: "Salir a correr", priority: 1), at: 2)
        thisWeek.addToDo(activity: Activity(name: "Leer", priority: 1), at: 3)
        thisWeek.addToDo(activity: Activity(name: "Comprar regalo para Pepe", priority: 0), at: 3)
        thisWeek.addToDo(activity: Activity(name: "Cumpleaños Pepe", priority: 0), at: 4)
        thisWeek.addToDo(activity: Activity(name: "Cocinar", priority: 0), at: 6)
        thisWeek.addToDo(activity: Activity(name: "Averiguar sobre algo", priority: 0), at: 7)
        
    }

//    MARK: - UITableView
    
    @IBOutlet weak var weekTableView: UITableView!{
        didSet{
            weekTableView.dataSource = self
            weekTableView.delegate = self
        }
    }
    
    
//    MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return thisWeek.days.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return thisWeek.days[section].Date
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thisWeek.days[section].activities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActionCell", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = thisWeek.days[indexPath.section].activities[indexPath.item].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            thisWeek.removeToDo(at: indexPath.section, position: indexPath.item)
            weekTableView.deleteRows(at: [indexPath], with: .fade)
            weekTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerCell = tableView.dequeueReusableCell(withIdentifier: "SectionCell") as? SectionTableViewCell{
            headerCell.titleLabel.text = thisWeek.days[section].Date
            return headerCell
        }else{
            return nil
        }
    }
    
    
}

