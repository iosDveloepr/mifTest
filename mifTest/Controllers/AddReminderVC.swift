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
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var reminderTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         managedObject = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
         reminderTextField.delegate = self
         messageTextField.delegate = self

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
            
            setNotification(title: title, message: message, time: triggerDate, identifier: uuid)
            saveToCoreData(title: title, message: message, date: datePicker.date, id: uuid)
            
            reminderTextField.text = ""
            messageTextField.text = ""
            
        } else {
            errorAlert()
        }
    }
    
    
    private func saveToCoreData(title: String, message: String, date: Date, id: String){
        
        let reminderObject = Reminder(context: managedObject)
        reminderObject.title = title
        reminderObject.message = message
        reminderObject.date = date
        reminderObject.id = id
        
        self.reminder = reminderObject
        delegate?.addReminder(value: reminder!)
        
        do{
            try self.managedObject.save()
        } catch {
            print (error.localizedDescription)
        }
    }
    
    
    
    private func setNotification (title: String, message: String, time : DateComponents, identifier : String){
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.sound = UNNotificationSound.default()
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: time, repeats: false)
        let center = UNUserNotificationCenter.current()
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content,
                                            trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if error != nil {
                print(error?.localizedDescription ?? "Nil error")
            }
        })
    }
    
    
    @IBAction func cancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func errorAlert(){
        let alert = UIAlertController(title: "Both text fields must be filled", message: "please complete the process", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
}
