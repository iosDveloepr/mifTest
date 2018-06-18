//
//  AddReminderVC.swift
//  mifTest
//
//  Created by Anton Yermakov on 12.06.2018.
//  Copyright © 2018 Anton Yermakov. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class AddReminderVC: UIViewController, UITextFieldDelegate {

    var managedObject: NSManagedObjectContext!

    var reminder: Reminder?
    var delegate: ReminderDelegate?
    var reminderToChange: Reminder?
    let centre = UNUserNotificationCenter.current()
    
    @IBOutlet weak var editLabel: UILabel!
    @IBOutlet weak var saveBtnOutlet: UIButton!
    @IBOutlet weak var editBtnOutlet: UIButton!
    @IBOutlet weak var cancelBtnOutlet: UIButton!
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var reminderTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        managedObject = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        reminderTextField.delegate = self
        messageTextField.delegate = self
        
        setupUI()
    }
    
    private func setupUI(){
        if reminderToChange != nil {
            saveBtnOutlet.isHidden = true
            cancelBtnOutlet.isHidden = true
            editLabel.text = "Edit reminder"
            reminderTextField.text = reminderToChange?.title
            messageTextField.text = reminderToChange?.message
        } else {
            editBtnOutlet.isHidden = true
            editLabel.text = ""
        }
    }
    
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
        reminderTextField.resignFirstResponder()
        messageTextField.resignFirstResponder()
        return true
    }

  
    @IBAction func saveReminder(_ sender: UIButton) {
        
        if reminderTextField.text != "" && messageTextField.text != "" {
            
            let uuid = UUID().uuidString
            guard let title = reminderTextField.text else { return }
            guard let message = messageTextField.text else { return }
            
            let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute, .second], from: datePicker.date)
            
           // setNotification(title: title, message: message, time: triggerDate, identifier: uuid)
             Notification.setNotification(title: reminderTextField.text!, message: messageTextField.text!, time: triggerDate, identifier: uuid)
            saveToCoreData(title: title, message: message, date: datePicker.date, id: uuid)
            
            reminderTextField.text = ""
            messageTextField.text = ""
            
        } else {
            errorAlert()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    private func saveToCoreData(title: String, message: String, date: Date, id: String){
        
        let reminderObject = Reminder(context: managedObject)
        reminderObject.title = title
        reminderObject.message = message
        reminderObject.date = date
        reminderObject.id = id
        
        self.reminder = reminderObject
        delegate?.addReminder(value: reminder!)
        

        CoreDataManager.sharedManager.trySave(managedObject: managedObject)
    }
    
    
    @IBAction func editReminder(_ sender: UIButton) {
        
        if reminderTextField.text != "" && messageTextField.text != "" {
            
            centre.removePendingNotificationRequests(withIdentifiers: [(reminderToChange?.id)!])
            
            reminderToChange?.setValue(reminderTextField.text, forKey: "title")
            reminderToChange?.setValue(messageTextField.text, forKey: "message")
            reminderToChange?.setValue(datePicker.date, forKey: "date")
            
            let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute, .second], from: datePicker.date)
            
          Notification.setNotification(title: reminderTextField.text!, message: messageTextField.text!, time: triggerDate, identifier: (reminderToChange?.id)!)
            
          CoreDataManager.sharedManager.trySave(managedObject: managedObject)
            
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    

    
    
  func errorAlert(){
        let alert = UIAlertController(title: "Both text fields must be filled", message: "please complete the process", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    @IBAction func cancellButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
} // class
