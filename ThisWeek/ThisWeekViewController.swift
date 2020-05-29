//
//  ViewController.swift
//  ThisWeek
//
//  Created by Emanuel on 26/05/2020.
//  Copyright © 2020 Emanuel. All rights reserved.
//

import UIKit
import EventKit

class ThisWeekViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SectionTableViewCellDelegate, SetReminderViewControllerDelegate {
//    MARK: - App Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "This Week Logo!"
        //TODO: Add a logo here
//        let logo = UIImage(named: "logo.png")
//        let imageView = UIImageView(image:logo)
//        self.navigationItem.titleView = imageView
    }
    
//    MARK: - Model
    private var thisWeek = ThisWeek(numberOfDays: ThisWeek.Defaults.numberOfDays)
    

//    MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        thisWeek.addToDo(activity: Activity(name: "Planchar", hasAReminder: false,completed: false, alarm: nil), at: 0)
        thisWeek.addToDo(activity: Activity(name: "Ir a comprar", hasAReminder: false,completed: false, alarm: nil), at: 0)
        thisWeek.addToDo(activity: Activity(name: "Reunion con Pepe", hasAReminder: false,completed: false, alarm: nil), at: 1)
        thisWeek.addToDo(activity: Activity(name: "Salir a correr", hasAReminder: false,completed: false, alarm: nil), at: 2)
        thisWeek.addToDo(activity: Activity(name: "Leer", hasAReminder: false,completed: false, alarm: nil), at: 3)
        thisWeek.addToDo(activity: Activity(name: "Comprar regalo para Pepe", hasAReminder: false,completed: false, alarm: nil), at: 3)
        thisWeek.addToDo(activity: Activity(name: "Cumpleaños Pepe", hasAReminder: false,completed: false, alarm: nil), at: 4)
        thisWeek.addToDo(activity: Activity(name: "Cocinar", hasAReminder: false,completed: false, alarm: nil), at: 6)
        thisWeek.addToDo(activity: Activity(name: "Averiguar sobre algo", hasAReminder: false,completed: false, alarm: nil), at: 7)
        
    }

//    MARK: - UITableView
    
    @IBOutlet weak var weekTableView: UITableView!{
        didSet{
            weekTableView.dataSource = self
            weekTableView.delegate = self
            weekTableView.setEditing(false, animated: true)
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
            // Single tap to stop reordering rows
            let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(disableEditingTable))
            singleTapGesture.numberOfTapsRequired = 1
            cell.addGestureRecognizer(singleTapGesture)
            // Long press to start reordering rows
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(enableEditingTable))
            cell.addGestureRecognizer(longPress)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "UndoneActionCell", for: indexPath) as? UndoneActionTableViewCell
            cell?.taskTextField.attributedText = alignLeftAttributedString( thisWeek.days[indexPath.section].getActivities()[indexPath.item].getName()! , fontsize: preferredRowSize * Defaults.rowTextSizeFactor , strikethrough: false)
            // Single tap to stop reordering rows
            let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(disableEditingTable))
            singleTapGesture.numberOfTapsRequired = 1
            cell?.addGestureRecognizer(singleTapGesture)
            // Two taps to start editing row text
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(startEditingTextField))
            tapGesture.numberOfTapsRequired = 2
            cell?.addGestureRecognizer(tapGesture)
            // Long press to start reordering rows
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(enableEditingTable))
            cell?.addGestureRecognizer(longPress)
            //Resignation handler to execute when the textfield is done
            cell?.resignationHandler = { [weak self, unowned cell] in
                if let text = cell!.taskTextField.text{
                    self?.thisWeek.days[indexPath.section].getActivities()[indexPath.item].setName(with: text)
                }
                self?.weekTableView.reloadData()
            }
            cell?.addReminderButtonHandler = { [weak self] in
                self!.taskToRemind = self!.thisWeek.days[indexPath.section].getActivities()[indexPath.item].getName()!
                self!.dateToRemind = self!.thisWeek.days[indexPath.section].getDate()!
                self!.sectionToRemind = indexPath.section
                self!.itemToRemind = indexPath.item
                self!.hasReminder = self!.thisWeek.days[indexPath.section].getActivities()[indexPath.item].hasItAReminder()!
                self!.performSegue(withIdentifier: "SetTime", sender: self)
            }
            if indexPath.section == thisWeek.days.count-1{
                cell?.addNewReminderButton.isHidden = true
            }else{
                cell?.addNewReminderButton.isHidden = false
                if thisWeek.days[indexPath.section].getActivities()[indexPath.item].hasItAReminder()!{
                    cell?.addNewReminderButton.backgroundColor = .yellow
                }else{
                    cell?.addNewReminderButton.backgroundColor = .clear
                }
            }
            
            
            return cell!
        }
    }
    private var itemToRemind = 0
    private var sectionToRemind = 0
    private var taskToRemind = ""
    private var dateToRemind = ""
    private var hasReminder = false
    
    
    private var preferredRowSize = CGFloat(0)
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        preferredRowSize = view.bounds.height * Defaults.rowSizeFactor
        return preferredRowSize
    }
    
    //  MARK: Gestures selectors
    @objc func disableEditingTable(sender : UITapGestureRecognizer){
        if weekTableView.isEditing == true {
            weekTableView.setEditing(false, animated: true)
        }
    }
    
    @objc func startEditingTextField( sender: UITapGestureRecognizer){
        if let cell = sender.view as? UndoneActionTableViewCell{
            cell.startEditing()
        }
    }
    
    @objc func enableEditingTable(sender : UILongPressGestureRecognizer){
        if weekTableView.isEditing == false{
            weekTableView.setEditing(true, animated: true)
        }
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
            if self.thisWeek.days[indexPath.section].getActivities()[indexPath.item].hasItAReminder()! {
                self.removeReminder(alarm : self.thisWeek.days[indexPath.section].getActivities()[indexPath.item].getAlarm()!, withTitle: self.thisWeek.days[indexPath.section].getActivities()[indexPath.item].getName()!)
                self.thisWeek.days[indexPath.section].getActivities()[indexPath.item].setAlarm(with: nil)
                self.thisWeek.days[indexPath.section].getActivities()[indexPath.item].setHasAReminder(with: false)
            }
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
    
    //  MARK: MoveRow
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if weekTableView.isEditing{
            return .none
        }else{
            return .delete
        }
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if (destinationIndexPath.section != sourceIndexPath.section) && thisWeek.days[sourceIndexPath.section].getActivities()[sourceIndexPath.item].hasItAReminder()! {
            removeReminder(alarm : thisWeek.days[sourceIndexPath.section].getActivities()[sourceIndexPath.item].getAlarm()!, withTitle: thisWeek.days[sourceIndexPath.section].getActivities()[sourceIndexPath.item].getName()!)
            thisWeek.days[sourceIndexPath.section].getActivities()[sourceIndexPath.item].setAlarm(with: nil)
            thisWeek.days[sourceIndexPath.section].getActivities()[sourceIndexPath.item].setHasAReminder(with: false)
        }
        let movedItem = thisWeek.removeToDo(at: sourceIndexPath.section, position: sourceIndexPath.item)
        thisWeek.days[destinationIndexPath.section].insertActivity(newElement: movedItem, at: destinationIndexPath.item)
        thisWeek.days[destinationIndexPath.section].sortDay()
        weekTableView.reloadData()
    }
    
    //    MARK: Header
    
    private func titleAttributedString(_ string: String, fontsize:CGFloat) -> NSAttributedString{
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
                thisWeek.addToDo(activity: Activity(name: ThisWeek.Defaults.newTaskText, hasAReminder: false, completed: false, alarm: nil), at: index)
                thisWeek.days[index].sortDay()
                weekTableView.reloadData()
            }
        }
    }
    
//    MARK: - SetReminderViewControllerDelegate
    
    var eventStore : EKEventStore!
    
    func addReminder(_ sender: SetReminderViewController) {
        if thisWeek.days[sectionToRemind].getActivities()[itemToRemind].hasItAReminder()!{
            removeReminder(alarm :self.thisWeek.days[self.sectionToRemind].getActivities()[self.itemToRemind].getAlarm()! ,  withTitle: self.taskToRemind)
        }
        
        eventStore = EKEventStore()
        eventStore.requestAccess(to: EKEntityType.reminder, completion: {
            granted, error in
            if (granted) && (error == nil) {
                let reminder : EKReminder = EKReminder(eventStore: self.eventStore)
                reminder.title = self.taskToRemind
                
                let chosenTime = sender.reminderDay
                let alarmTime = chosenTime.addingTimeInterval(TimeInterval(exactly: self.sectionToRemind*ThisWeek.Defaults.oneDay) ?? 0)
                let alarm = EKAlarm(absoluteDate: alarmTime)
                reminder.addAlarm(alarm)
                
                reminder.calendar = self.eventStore.defaultCalendarForNewReminders()
                
                do {
                    try self.eventStore.save(reminder, commit: true)
                } catch {
                    return
                }
                
//                print("Reminder saved")
                self.thisWeek.days[self.sectionToRemind].getActivities()[self.itemToRemind].setHasAReminder(with: true)
                self.thisWeek.days[self.sectionToRemind].getActivities()[self.itemToRemind].setAlarm(with: reminder.alarms?.first)
                DispatchQueue.main.async {
                    self.weekTableView.reloadData()
                }
                
            }
        })
    }
    
    func deleteReminder(_ sender: SetReminderViewController) {
        if thisWeek.days[sectionToRemind].getActivities()[itemToRemind].hasItAReminder()!{
            removeReminder(alarm :thisWeek.days[sectionToRemind].getActivities()[itemToRemind].getAlarm()! ,  withTitle:taskToRemind)
            thisWeek.days[sectionToRemind].getActivities()[itemToRemind].setAlarm(with: nil)
            thisWeek.days[sectionToRemind].getActivities()[itemToRemind].setHasAReminder(with: false)
            weekTableView.reloadData()
        }
    }
    
    private func removeReminder(alarm : EKAlarm, withTitle taskTitle: String){
        let calendar = eventStore.defaultCalendarForNewReminders()
        var myReminders = [EKReminder]()
        let predicate = self.eventStore.predicateForReminders(in: [calendar!])
        self.eventStore.fetchReminders(matching: predicate, completion:{ (reminders: [EKReminder]?) -> Void in
            myReminders = reminders!
            do{
                try self.eventStore.remove(myReminders.filter{ $0.title == taskTitle && $0.alarms?.first! == alarm}.first!, commit: true)
            }catch{
//                print("An error occurred while removing the reminder from the Calendar database: \(error)")
            }
        })
    }
    
//  MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SetTime"{
            if let destination = segue.destination as? SetReminderViewController, let source = segue.source as? ThisWeekViewController{
                destination.delegate = self
                destination.deleteButtonNeeded = source.hasReminder
            }
        }
    }
}

// MARK: - ViewController Extension

extension ThisWeekViewController {
    struct Defaults {
        static let headerSizeFactor = CGFloat(0.05)
        static let headerTextSizeFactor = CGFloat(0.5)
        static let rowSizeFactor = CGFloat(0.05)
        static let rowTextSizeFactor = CGFloat(0.45)
        static let cancelButtonText = "Cancelar"
        static let setButtonText = "Establecer"
        static let pickTimeText = "Elegir el horario de la alarma:"
        static let deleteButtonText = "Eliminar recordatorio"
        static let pickerSizeFactor = CGFloat(1.2)
    }
}

