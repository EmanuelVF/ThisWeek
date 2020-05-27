//
//  ViewController.swift
//  ThisWeek
//
//  Created by Emanuel on 26/05/2020.
//  Copyright © 2020 Emanuel. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SectionTableViewCellDelegate {
    
    
//    MARK: - Model
    private var thisWeek = ThisWeek(numberOfDays: ThisWeek.Defaults.numberOfDays)
    

//    MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        thisWeek.addToDo(activity: Activity(name: "Planchar", priority: 0,completed: false), at: 0)
        thisWeek.addToDo(activity: Activity(name: "Ir a comprar", priority: 0,completed: false), at: 0)
        thisWeek.addToDo(activity: Activity(name: "Reunion con Pepe", priority: 0,completed: false), at: 1)
        thisWeek.addToDo(activity: Activity(name: "Salir a correr", priority: 1,completed: false), at: 2)
        thisWeek.addToDo(activity: Activity(name: "Leer", priority: 1,completed: false), at: 3)
        thisWeek.addToDo(activity: Activity(name: "Comprar regalo para Pepe", priority: 0,completed: false), at: 3)
        thisWeek.addToDo(activity: Activity(name: "Cumpleaños Pepe", priority: 0,completed: false), at: 4)
        thisWeek.addToDo(activity: Activity(name: "Cocinar", priority: 0,completed: false), at: 6)
        thisWeek.addToDo(activity: Activity(name: "Averiguar sobre algo", priority: 0,completed: false), at: 7)
        
    }

//    MARK: - UITableView
    
    @IBOutlet weak var weekTableView: UITableView!{
        didSet{
            weekTableView.dataSource = self
            weekTableView.delegate = self
        }
    }
    
    
//    MARK: - UITableViewDataSource & UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return thisWeek.days.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return thisWeek.days[section].getDate()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thisWeek.days[section].getActivities().count
    }

    private func alignLeftAttributedString(_ string: String, fontsize:CGFloat, strikethrough : Bool) -> NSAttributedString{
        print("hola \(fontsize)")
        var font = UIFont.preferredFont(forTextStyle: .title1).withSize(fontsize)
        font = UIFontMetrics(forTextStyle: .title1).scaledFont(for: font) // This update the text size with metrics
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        if strikethrough{
            return NSAttributedString(string: string, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle, .font: font, .strikethroughStyle: NSUnderlineStyle.single.rawValue])
        }else{
            return NSAttributedString(string: string, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle, .font: font])
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if thisWeek.days[indexPath.section].getActivities()[indexPath.item].isCompleted()!{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DoneActionCell", for: indexPath)
            cell.textLabel?.attributedText = alignLeftAttributedString( thisWeek.days[indexPath.section].getActivities()[indexPath.item].getName()! , fontsize: preferredRowSize * Defaults.rowTextSizeFactor, strikethrough: true)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "UndoneActionCell", for: indexPath) as? UndoneActionTableViewCell
            print(weekTableView.rowHeight)
            cell?.taskTextField.attributedText = alignLeftAttributedString( thisWeek.days[indexPath.section].getActivities()[indexPath.item].getName()! , fontsize: preferredRowSize * Defaults.rowTextSizeFactor , strikethrough: false)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(startEditing))
            tapGesture.numberOfTapsRequired = 2
            cell?.addGestureRecognizer(tapGesture)
            cell?.resignationHandler = { [weak self, unowned cell] in
                if let text = cell!.taskTextField.text{
                    self?.thisWeek.days[indexPath.section].getActivities()[indexPath.item].setName(with: text)
                }
                self?.weekTableView.reloadData()
            }
            return cell!
        }
    }
    
    @objc func startEditing( sender: UITapGestureRecognizer){
        if let cell = sender.view as? UndoneActionTableViewCell{
            cell.startEditing()
        }
    }
    
    private var preferredRowSize = CGFloat(0)
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        preferredRowSize = view.bounds.height * Defaults.rowSizeFactor
        return preferredRowSize
    }
    
    
    //    MARK: Custom Deleting
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if thisWeek.days[indexPath.section].getActivities()[indexPath.item].isCompleted()! {
                thisWeek.removeToDo(at: indexPath.section, position: indexPath.item)
                weekTableView.deleteRows(at: [indexPath], with: .fade)
                weekTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipe = UIContextualAction(style: .normal, title: ThisWeek.Defaults.doneText){(action, sourceView, completionHandler) in
            self.thisWeek.days[indexPath.section].getActivities()[indexPath.item].complete()
            self.thisWeek.days[indexPath.section].sortDay()
            self.weekTableView.reloadData()
            completionHandler(true)
        }
        swipe.backgroundColor = UIColor.green
        
        if !thisWeek.days[indexPath.section].getActivities()[indexPath.item].isCompleted()! {
            let swipeTrailingAction = UISwipeActionsConfiguration(actions: [swipe])
            swipeTrailingAction.performsFirstActionWithFullSwipe = true
            return swipeTrailingAction
        }else{
            return nil
        }
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipe = UIContextualAction(style: .normal, title: ThisWeek.Defaults.unDoneText){(action, sourceView, completionHandler) in
            self.thisWeek.days[indexPath.section].getActivities()[indexPath.item].unComplete()
            self.thisWeek.days[indexPath.section].sortDay()
            self.weekTableView.reloadData()
            completionHandler(true)
        }
        swipe.backgroundColor = UIColor.blue
        
        if thisWeek.days[indexPath.section].getActivities()[indexPath.item].isCompleted()!{
            let swipeLeadingAction = UISwipeActionsConfiguration(actions: [swipe])
            swipeLeadingAction.performsFirstActionWithFullSwipe = true
            return swipeLeadingAction
        }else{
            return nil
        }
    }
    
    //    MARK: Header
    
    private func titleAttributedString(_ string: String, fontsize:CGFloat) -> NSAttributedString{
        print("hola \(fontsize)")
        var font = UIFont.preferredFont(forTextStyle: .title1).withSize(fontsize)
        font = UIFontMetrics(forTextStyle: .title1).scaledFont(for: font) // This update the text size with metrics
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle, .font: font])
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerCell = tableView.dequeueReusableCell(withIdentifier: "SectionCell") as? SectionTableViewCell{
            headerCell.titleLabel.attributedText = titleAttributedString(thisWeek.days[section].getDate()!, fontsize: preferredHeaderHeight * Defaults.headerTextSizeFactor)
            headerCell.delegate = self
            return headerCell
        }else{
            return nil
        }
    }
    
    private var preferredHeaderHeight = CGFloat(0)
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        preferredHeaderHeight = view.bounds.height * Defaults.headerSizeFactor
        return preferredHeaderHeight
    }
    
//      MARK: -  SectionTableViewCellDelegate
    
    func addOneTask(_ sender: SectionTableViewCell) {
        
        let text = sender.titleLabel.text
        for index in thisWeek.days.indices{
            if thisWeek.days[index].getDate()! == text!{
                thisWeek.addToDo(activity: Activity(name: ThisWeek.Defaults.newTaskText, priority: 0,completed: false), at: index)
                weekTableView.reloadData()
            }
        }
    }
    
}

// MARK: - ViewController Extension

extension ViewController {
    struct Defaults {
        static let headerSizeFactor = CGFloat(0.05)
        static let headerTextSizeFactor = CGFloat(0.5)
        static let rowSizeFactor = CGFloat(0.05)
        static let rowTextSizeFactor = CGFloat(0.45)
    }
}

