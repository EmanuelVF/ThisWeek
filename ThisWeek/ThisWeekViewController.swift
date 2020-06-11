//
//  ViewController.swift
//  ThisWeek
//
//  Created by Emanuel on 26/05/2020.
//  Copyright © 2020 Emanuel. All rights reserved.
//

import UIKit
import UserNotifications

class ThisWeekViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SectionTableViewCellDelegate, SetReminderViewControllerDelegate, SetDateViewControllerDelegate, UndoneActionTableViewCellDelegate  {
    
//    MARK: - Model
    var thisWeek = ThisWeek(startingWith: Date(), numberOfDays: ThisWeek.Defaults.numberOfDays)

//    MARK: - ViewController Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadLogo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        weekTableView.reloadData()
    }
    
    private func loadLogo(){
        let image = UIImage(named: Defaults.logoName)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
    
    private var keyboardWillShowObserver : NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        addNotificationsObserver()
//        thisWeek.refresh(basedOn: thisWeek.days.first!.getLongDate()!,numberOfDays: ThisWeek.Defaults.numberOfDays)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //TODO: Delete This
        print("User defaults: Onboarding = false")
        UserDefaults.standard.set(false, forKey: "OnboardingDone")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
        removeNotificationsObserver()
    }
    
    //    MARK: Keyboard Moves
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            weekTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height * Defaults.keyboardContentFactor, right: 0)
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
            weekTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
            let cell = tableView.dequeueReusableCell(withIdentifier: Defaults.cellIDDoneAction, for: indexPath)
            cell.textLabel?.attributedText = alignLeftAttributedString( thisWeek.days[indexPath.section].getActivities()[indexPath.item].getName()! , fontsize: preferredRowSize * Defaults.rowTextSizeFactor, strikethrough: true)
            // Single tap to stop reordering rows
            let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(disableEditingTable))
            singleTapGesture.numberOfTapsRequired = Defaults.numberOfTapsForStopReordering
            cell.addGestureRecognizer(singleTapGesture)
            // Long press to start reordering rows
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(enableEditingTable))
            cell.addGestureRecognizer(longPress)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: Defaults.cellIDUndoneAction, for: indexPath) as? UndoneActionTableViewCell
            cell?.delegate = self
            cell?.taskTextField.attributedText = alignLeftAttributedString( thisWeek.days[indexPath.section].getActivities()[indexPath.item].getName()! , fontsize: preferredRowSize * Defaults.rowTextSizeFactor , strikethrough: false)
            // Single tap to stop reordering rows
            let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(disableEditingTable))
            singleTapGesture.numberOfTapsRequired = Defaults.numberOfTapsForStopReordering
            cell?.addGestureRecognizer(singleTapGesture)
            // Two taps to start editing row text
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(startEditingTextField))
            tapGesture.numberOfTapsRequired = Defaults.numberOfTapsForStartEditingText
            cell?.addGestureRecognizer(tapGesture)
            // Long press to start reordering rows
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(enableEditingTable))
            cell?.addGestureRecognizer(longPress)
            //Resignation handler to execute when the textfield is done
            cell?.resignationHandler = { [weak self] in
                self!.sectionToRemind = indexPath.section
                self!.itemToRemind = indexPath.item
                self!.isEditingText = false
            }
            cell?.addReminderButtonHandler = { [weak self] in
                self!.taskToRemind = self!.thisWeek.days[indexPath.section].getActivities()[indexPath.item].getName()!
                self!.dateToRemind = self!.thisWeek.days[indexPath.section].getDate()!
                self!.sectionToRemind = indexPath.section
                self!.itemToRemind = indexPath.item
                self!.hasReminder = self!.thisWeek.days[indexPath.section].getActivities()[indexPath.item].hasItAReminder()!
                if(!self!.isEditingText){
                    if indexPath.section == self!.thisWeek.days.count-1{
                        self!.futureDay = self!.thisWeek.days[indexPath.section].getActivities()[indexPath.item].getFutureDay()
                        self!.performSegue(withIdentifier: Defaults.IDFromMaintoDate, sender: self)
                    }else{
                        self!.performSegue(withIdentifier: Defaults.IDFromMainToTime, sender: self)
                    }
                }
            }
            if indexPath.section == thisWeek.days.count-1{
                cell?.buttonString = Defaults.dateButton
                if thisWeek.days[indexPath.section].getActivities()[indexPath.item].getFutureDay() != nil{
                    cell?.addNewReminderButton.backgroundColor = Defaults.backgorundColorSet
                }else{
                    cell?.addNewReminderButton.backgroundColor = Defaults.backgorundColorReset
                }
            }else{
                cell?.buttonString = Defaults.reminderButton
                if thisWeek.days[indexPath.section].getActivities()[indexPath.item].hasItAReminder()!{
                    cell?.addNewReminderButton.backgroundColor = Defaults.backgorundColorSet
                }else{
                    cell?.addNewReminderButton.backgroundColor = Defaults.backgorundColorReset
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
    private var futureDay : Date? = nil
    
    
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
    
    private var isEditingText = false
    
    @objc func startEditingTextField( sender: UITapGestureRecognizer){
        if let cell = sender.view as? UndoneActionTableViewCell{
            cell.startEditing()
            isEditingText = true
        }
    }
    
    @objc func enableEditingTable(sender : UILongPressGestureRecognizer){
        if weekTableView.isEditing == false && !isEditingText{
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
                _ = thisWeek.removeToDo(at: indexPath.section, position: indexPath.item)
                weekTableView.deleteRows(at: [indexPath], with: .fade)
                deleteActions()
                weekTableView.reloadData()
            }
        }
    }
    
    func deleteActions(){
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipe = UIContextualAction(style: .normal, title: ThisWeek.Defaults.doneText){(action, sourceView, completionHandler) in
            self.thisWeek.days[indexPath.section].getActivities()[indexPath.item].complete()
            if self.thisWeek.days[indexPath.section].getActivities()[indexPath.item].hasItAReminder()! {
                self.removeReminder(alarm : self.thisWeek.days[indexPath.section].getActivities()[indexPath.item].getAlarm()!, withTitle: self.thisWeek.days[indexPath.section].getActivities()[indexPath.item].getName()!)
                self.thisWeek.days[indexPath.section].getActivities()[indexPath.item].setAlarm(with: nil)
                self.thisWeek.days[indexPath.section].getActivities()[indexPath.item].setHasAReminder(with: false)
                self.thisWeek.days[indexPath.section].getActivities()[indexPath.item].setAlarmTime(with: nil)
            }
            self.thisWeek.days[indexPath.section].sortDay()
            self.weekTableView.reloadData()
            self.doneActions()
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
    
    func doneActions(){
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipe = UIContextualAction(style: .normal, title: ThisWeek.Defaults.unDoneText){(action, sourceView, completionHandler) in
            self.thisWeek.days[indexPath.section].getActivities()[indexPath.item].unComplete()
            self.thisWeek.days[indexPath.section].sortDay()
            self.undoneActions()
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
    
    func undoneActions(){
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
            thisWeek.days[sourceIndexPath.section].getActivities()[sourceIndexPath.item].setAlarmTime(with: nil)
        }
        let movedItem = thisWeek.removeToDo(at: sourceIndexPath.section, position: sourceIndexPath.item)
        thisWeek.days[destinationIndexPath.section].insertActivity(newElement: movedItem, at: destinationIndexPath.item)
        thisWeek.days[destinationIndexPath.section].sortDay()
        insertActions()
        weekTableView.reloadData()
    }
        
    func insertActions(){
        
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
        if let headerCell = tableView.dequeueReusableCell(withIdentifier: Defaults.cellIDSection) as? SectionTableViewCell{
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
                thisWeek.addToDo(activity: Activity(name: ThisWeek.Defaults.newTaskText, hasAReminder: false, completed: false, alarmID: nil, alarmTime: nil, futureDay: nil), at: index)
                thisWeek.days[index].sortDay()
                weekTableView.reloadData()
            }
        }
    }
    
    
//      MARK: -  UndoneActionTableViewCell
    func endEditingTask(_ sender: UndoneActionTableViewCell) {
            if let text = sender.taskTextField.text{
                thisWeek.days[sectionToRemind].getActivities()[itemToRemind].setName(with: text)
            }
            weekTableView.reloadData()
    }
    
    
//    MARK: - SetReminderViewControllerDelegate
    
    func addReminder(_ sender: SetReminderViewController) {
        
        let center = UNUserNotificationCenter.current()
        
        if thisWeek.days[sectionToRemind].getActivities()[itemToRemind].hasItAReminder()!{
            removeReminder(alarm :self.thisWeek.days[self.sectionToRemind].getActivities()[self.itemToRemind].getAlarm()! ,  withTitle: self.taskToRemind)
        }
        
        let alarmID = UUID().uuidString
        
        let content = UNMutableNotificationContent()
        content.title = Defaults.notificationTitle
        content.body = self.taskToRemind
        content.categoryIdentifier = Defaults.notificationCategoryAlert
        content.sound = .default
        content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
        content.userInfo = [Defaults.notificationUserDefaultsTaskName : self.taskToRemind,
                            Defaults.notificationUserDefaultsAlarmID : alarmID]
        
        let chosenTime = sender.reminderDay
        let alarmTime = chosenTime.addingTimeInterval(TimeInterval(exactly: self.sectionToRemind*ThisWeek.Defaults.oneDay) ?? 0)
        let alarmTimeComps = Calendar.current.dateComponents([.year, .month, .day,.hour,.minute], from: alarmTime)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: alarmTimeComps, repeats: false)
        
        let request = UNNotificationRequest(identifier: alarmID, content: content, trigger : trigger)
        center.add(request) { (error) in
            //TODO: Parse error
        }
        self.thisWeek.days[self.sectionToRemind].getActivities()[self.itemToRemind].setAlarmTime(with: alarmTime)
        self.thisWeek.days[self.sectionToRemind].getActivities()[self.itemToRemind].setHasAReminder(with: true)
        self.thisWeek.days[self.sectionToRemind].getActivities()[self.itemToRemind].setAlarm(with: alarmID)
        DispatchQueue.main.async {
            self.weekTableView.reloadData()
        }
    }
    
    func deleteReminder(_ sender: SetReminderViewController) {
        if thisWeek.days[sectionToRemind].getActivities()[itemToRemind].hasItAReminder()!{
            removeReminder(alarm :thisWeek.days[sectionToRemind].getActivities()[itemToRemind].getAlarm()! ,  withTitle:taskToRemind)
            thisWeek.days[sectionToRemind].getActivities()[itemToRemind].setAlarm(with: nil)
            thisWeek.days[sectionToRemind].getActivities()[itemToRemind].setHasAReminder(with: false)
            thisWeek.days[sectionToRemind].getActivities()[itemToRemind].setAlarmTime(with: nil)
            weekTableView.reloadData()
        }
    }
    
    private func removeReminder(alarm : String, withTitle taskTitle: String){
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [alarm])
        DispatchQueue.main.async {
            self.weekTableView.reloadData()
        }
    }
    
//    MARK:- SetDateViewControllerDelegate
    func setAFutureDay(_ sender: SetDateViewController) {
        thisWeek.days[sectionToRemind].getActivities()[itemToRemind].setFutureDay(with: sender.newDayToRemember!)
        weekTableView.reloadData()
    }
    
    func deleteAFutureDay(_ sender: SetDateViewController) {
        thisWeek.days[sectionToRemind].getActivities()[itemToRemind].setFutureDay(with: nil)
        weekTableView.reloadData()
    }
    
//  MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Defaults.IDFromMainToTime{
            if let destination = segue.destination as? SetReminderViewController, let source = segue.source as? ThisWeekViewController{
                destination.delegate = self
                destination.deleteButtonNeeded = source.hasReminder
                if source.hasReminder {
                    destination.actualTime = thisWeek.days[source.sectionToRemind].getActivities()[source.itemToRemind].getAlarmTime()!
                }else{
                    destination.actualTime = nil
                }
            }
        }
        if segue.identifier == Defaults.IDFromMaintoDate{
            if let destination = segue.destination as? SetDateViewController, let source = segue.source as? ThisWeekViewController{
                destination.delegate = self
                destination.dayToRemember = source.futureDay
                if source.futureDay == nil{
                    destination.editingMode = false
                }else{
                    destination.editingMode = true
                }
            }
        }
    }
    
//  MARK:- Notification response
    
    private var doneNotificationObserver : NSObjectProtocol?
    private var undoneNotificationObserver : NSObjectProtocol?
    
    func addNotificationsObserver(){
        doneNotificationObserver = NotificationCenter.default.addObserver(
        forName: .DoneNotification,
        object: nil,
        queue: OperationQueue.main,
        using: { (notification) in
            if let userInfo = notification.userInfo?[NotificationFromUser.DoneNotificationKey] as? [String:String]{
                self.doneActionfromNotification(taskName: userInfo[Defaults.notificationUserDefaultsTaskName], alarmID: userInfo[Defaults.notificationUserDefaultsAlarmID])
            }
        })
        
        undoneNotificationObserver = NotificationCenter.default.addObserver(
        forName: .UndoneNotification,
        object: nil,
        queue: OperationQueue.main,
        using: { (notification) in
            if let userInfo = notification.userInfo?[NotificationFromUser.UndoneNotificationKey] as? [String:String]{
                self.undoneActionfromNotification(taskName: userInfo[Defaults.notificationUserDefaultsTaskName], alarmID: userInfo[Defaults.notificationUserDefaultsAlarmID])
            }
        })
    }
    
    func undoneActionfromNotification(taskName : String?, alarmID :String?){
        removeReminder(alarm: alarmID!, withTitle: taskName!)
        for index in self.thisWeek.days.first!.getActivities().indices{
            if self.thisWeek.days.first!.getActivities()[index].getName() == taskName{
                self.thisWeek.days.first!.getActivities()[index].setAlarm(with: nil)
                self.thisWeek.days.first!.getActivities()[index].setHasAReminder(with: false)
                self.thisWeek.days.first!.getActivities()[index].setAlarmTime(with: nil)
                
            }
        }
        self.weekTableView.reloadData()
        
    }
    
    func doneActionfromNotification(taskName : String?, alarmID :String?){
        removeReminder(alarm: alarmID!, withTitle: taskName!)
        for index in self.thisWeek.days.first!.getActivities().indices{
            if self.thisWeek.days.first!.getActivities()[index].getName() == taskName{
                self.thisWeek.days.first!.getActivities()[index].complete()
                self.thisWeek.days.first!.getActivities()[index].setAlarm(with: nil)
                self.thisWeek.days.first!.getActivities()[index].setHasAReminder(with: false)
                self.thisWeek.days.first!.getActivities()[index].setAlarmTime(with: nil)
            }
        }
        self.thisWeek.days.first!.sortDay()
        self.weekTableView.reloadData()
    }
    
    func removeNotificationsObserver(){
        if let observer = doneNotificationObserver{
            NotificationCenter.default.removeObserver(observer)
        }
        
        if let observer = undoneNotificationObserver{
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
//    MARK:- External functions
    
    func syncAllNotifications(){
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        
        // Delete Delivered Notifications
        for dayIndex in thisWeek.days.indices{
            for taskIndex in thisWeek.days[dayIndex].getActivities().indices{
                if let hasAReminder = self.thisWeek.days[dayIndex].getActivities()[taskIndex].hasItAReminder() , hasAReminder  {
                    if thisWeek.days[dayIndex].getActivities()[taskIndex].getAlarmTime()! < Date(){
                        thisWeek.days[dayIndex].getActivities()[taskIndex].setAlarmTime(with: nil)
                        thisWeek.days[dayIndex].getActivities()[taskIndex].setAlarm(with: nil)
                        thisWeek.days[dayIndex].getActivities()[taskIndex].setHasAReminder(with: false)
                    }
                }
            }
        }
        
        //Delete future notifications unparent
        center.getPendingNotificationRequests { (notifications) in
            for indexNotifications in notifications.indices{
                var notificationOk = false
                for dayIndex in self.thisWeek.days.indices{
                    for taskIndex in self.thisWeek.days[dayIndex].getActivities().indices{
                        if let hasAReminder = self.thisWeek.days[dayIndex].getActivities()[taskIndex].hasItAReminder() , hasAReminder  {
                            if notifications[indexNotifications].identifier == self.thisWeek.days[dayIndex].getActivities()[taskIndex].getAlarm()! {
                                notificationOk = true
                            }
                        }
                    }
                }
                if !notificationOk {
                    center.removePendingNotificationRequests(withIdentifiers: [notifications[indexNotifications].identifier])
                }
            }
        }
        
        //Set Missing Notifications
        center.getPendingNotificationRequests { (notifications) in
            for dayIndex in self.thisWeek.days.indices{
                for taskIndex in self.thisWeek.days[dayIndex].getActivities().indices{
                    if let hasAReminder = self.thisWeek.days[dayIndex].getActivities()[taskIndex].hasItAReminder() , hasAReminder  {
                        if self.thisWeek.days[dayIndex].getActivities()[taskIndex].getAlarmTime()! > Date(){
                            var notificationSet = false
                            for notificationIndex in notifications.indices{
                                if notifications[notificationIndex].identifier == self.thisWeek.days[dayIndex].getActivities()[taskIndex].getAlarm()!{
                                    notificationSet = true
                                    break;
                                }
                            }
                            if !notificationSet{
                                DispatchQueue.main.async {
                                    self.setMissingNotification(date: self.thisWeek.days[dayIndex].getActivities()[taskIndex].getAlarmTime()!, title: self.thisWeek.days[dayIndex].getActivities()[taskIndex].getName()!,identifier: self.thisWeek.days[dayIndex].getActivities()[taskIndex].getAlarm()!)
                                }
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func setMissingNotification ( date: Date, title: String, identifier: String){
        
        let center = UNUserNotificationCenter.current()

        let alarmID = identifier
        
        let content = UNMutableNotificationContent()
        content.title = Defaults.notificationTitle
        content.body = title
        content.categoryIdentifier = Defaults.notificationCategoryAlert
        content.sound = .default
        content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
        content.userInfo = [Defaults.notificationUserDefaultsTaskName: title,
                            Defaults.notificationUserDefaultsAlarmID: identifier]
        
        let alarmTime = date
        let alarmTimeComps = Calendar.current.dateComponents([.year, .month, .day,.hour,.minute], from: alarmTime)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: alarmTimeComps, repeats: false)
        
        let request = UNNotificationRequest(identifier: alarmID, content: content, trigger : trigger)
        center.add(request) { (error) in
            //TODO: Parse error
        }

        DispatchQueue.main.async {
            self.weekTableView.reloadData()
        }
        
    }
}

// MARK: - ViewController Extension

extension ThisWeekViewController {
    struct Defaults {
        static let oneDay = 86400
        static let oneWeek = 8*86400
        static let headerSizeFactor = CGFloat(0.05)
        static let headerTextSizeFactor = CGFloat(0.47)
        static let rowSizeFactor = CGFloat(0.05)
        static let rowTextSizeFactor = CGFloat(0.45)
        static let keyboardContentFactor = CGFloat(1.1)
        //Cells Identifiers
        static let cellIDDoneAction = "DoneActionCell"
        static let cellIDUndoneAction = "UndoneActionCell"
        static let cellIDSection = "SectionCell"
        //Gestures
        static let numberOfTapsForStopReordering = 1
        static let numberOfTapsForStartEditingText = 2
        //Buttons
        static let reminderButton = "⏲"
        static let dateButton = "🗓"
        static let backgorundColorSet = UIColor.yellow
        static let backgorundColorReset = UIColor.clear
        //SetReminderViewController
        static let cancelButtonText = NSLocalizedString("Cancel", comment: "")
        static let setButtonText = NSLocalizedString("Set",comment: "")
        static let pickTimeText = NSLocalizedString("Pick the reminder time:",comment: "")
        static let deleteButtonText = NSLocalizedString("Delete reminder",comment: "")
        static let pickerSizeFactor = CGFloat(1.2)
        static let alertTitle = NSLocalizedString("Changes were made to your planning",comment: "")
        static let alertMessage = NSLocalizedString("As the day changed, your uncomplete tasks were moved to the last section.",comment: "")
        static let alertOk = NSLocalizedString("Acept",comment: "")
        //Logo
        static let logoName = "ThisWeekLogo+Title1.png"
        //SetDateViewContoller
        static let rightButtonTextChoose = NSLocalizedString("Choose",comment: "")
        static let rightButtonTextEdit = NSLocalizedString("Edit",comment: "")
        static let leftButtonTextCancel = NSLocalizedString("Cancel",comment: "")
        static let lastButtonTextDelete = NSLocalizedString("Delete date",comment: "")
        static let titleTextChoose = NSLocalizedString("Pick the task date:",comment: "")
        static let titleTextInfo = NSLocalizedString("Task assigned to the day",comment: "")
        //UserDefaults
        static let UserDefaultsOnBoardingDoneKey = "OnboardingDone"
        //Segues
        static let IDFromOnboardingToMain = "OnboardingDone"
        static let IDFromMaintoDate = "SetDate"
        static let IDFromMainToTime = "SetTime"
        //SectionTableViewCell
        static let addingButtonTitle = "⊕"
        //Files
        static let backUpFile = "Backup.json"
        //Notifications
        static let notificationTitle = NSLocalizedString("Remember to complete this action",comment: "")
        static let notificationCategoryAlert = "ActionAlert"
        static let notificationUserDefaultsTaskName = "TaskName"
        static let notificationUserDefaultsAlarmID = "alarmID"
        static let notificationActionIDForDone = "ACCEPT_ACTION"
        static let notificationActionTitleForDone = NSLocalizedString("Acept",comment: "")
        static let notificationActionIDForDecline = "DECLINE_ACTION"
        static let notificationActionTitleForDecline = NSLocalizedString("Decline",comment: "")
        //OnboardingMVC
        static let getStartedButtonText = NSLocalizedString("Get started!",comment: "")
        static let welcomeLabelText = NSLocalizedString("Welcome to This Week !",comment: "")
        static let subTitleLabelText = NSLocalizedString("With this app, you could:",comment: "")
        static let planLabelText = NSLocalizedString("Plan your week",comment: "")
        static let setLabelText = NSLocalizedString("Create reminders",comment: "")
        static let outlineLabelText = NSLocalizedString("Outline the future",comment: "")
    }
}

