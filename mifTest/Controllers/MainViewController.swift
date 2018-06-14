//
//  ViewController.swift
//  mifTest
//
//  Created by Anton Yermakov on 11.06.2018.
//  Copyright © 2018 Anton Yermakov. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var reminders = [Reminder]()
    var managedObject: NSManagedObjectContext!
    let centre = UNUserNotificationCenter.current()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
          managedObject = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
          loadData()
        
        
          tableView.estimatedRowHeight = 140
          tableView.rowHeight = UITableViewAutomaticDimension
    
    }
    
    private func loadData(){
       
        let request : NSFetchRequest<Reminder> = Reminder.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
      
        do {
            reminders = try managedObject.fetch(request)
        } catch {
            print (error.localizedDescription)
        }
        
        
        // Код для удаление старых напоминаний
        
//        for rem in reminders{
//            let remTime = rem.date?.description(with: .current)
//            let currenTime = Date().description(with: .current)
//            if remTime! < currenTime {
//
//                managedObject.delete(rem)
//                reminders.remove(at: rem.faultingState)
//                centre.removeDeliveredNotifications(withIdentifiers: [rem.id!])
//
//                do {
//                    try managedObject.save()
//                } catch {
//                    print(error.localizedDescription)
//                }
//
//                tableView.reloadData()
//            }
//        }
    }

    
    @IBAction func presentDataPicker(_ sender: UIBarButtonItem) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "reminderVC") as! AddReminderVC
        present(vc, animated: true)
        vc.delegate = self
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell", for: indexPath) as! MainTableViewCell
        
        let rem = reminders[indexPath.row]
   
        cell.titleLabel.text =  rem.title
        cell.messageLabel.text = rem.message
        if let date = rem.date{
            cell.dateLabel.text = stringFromDate(date: date)
        }
        return cell
    }
    
    
    private func stringFromDate(date: Date) -> String {
        let formater = DateFormatter()
        formater.dateStyle = .short
        formater.timeStyle = .short
        let locale = Locale.current
        formater.locale = locale
        return formater.string(from: date)
    }

    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            
            let toRemove = reminders[indexPath.row]
            managedObject.delete(toRemove)
            reminders.remove(at: indexPath.row)
        
            
            self.centre.removeDeliveredNotifications(withIdentifiers: [toRemove.id!])
            
            do {
                try managedObject.save()
            } catch {
                print(error.localizedDescription)
            }

            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
} // class



extension MainViewController: ReminderDelegate{
   
    func addReminder(value: Reminder) {
        self.reminders.append(value)
        self.tableView.reloadData()
        print(value)
    }
}





