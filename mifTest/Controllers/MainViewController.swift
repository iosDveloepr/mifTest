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
    let date = Date()
    
   @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        managedObject = CoreDataManager.sharedManager.persistentContainer.viewContext
        loadData()
        
        tableView.estimatedRowHeight = 140
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }
    

    
    private func loadData(){
       
        let request : NSFetchRequest<Reminder> = Reminder.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
      
        do {
            reminders = try managedObject.fetch(request)
        } catch {
            print (error.localizedDescription)
        }
    }

    
  
    @IBAction func presentDataPicker(_ sender: UIButton) {
        
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
        cell.reminder = rem
        
        if self.date > rem.date!{
            cell.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1.0)
            cell.messageLabel.textColor = .white
            cell.titleLabel.textColor = .white
            cell.dateLabel.textColor = .white
        }
        
        if self.date < rem.date!{
            cell.backgroundColor = UIColor(red: 0.2392, green: 0.9569, blue: 0.9569, alpha: 1.0)
            cell.messageLabel.textColor = .black
            cell.titleLabel.textColor = .black
            cell.dateLabel.textColor = .black
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            
            let toRemove = reminders[indexPath.row]
            managedObject.delete(toRemove)
            reminders.remove(at: indexPath.row)
        
            self.centre.removePendingNotificationRequests(withIdentifiers: [toRemove.id!])
            
            CoreDataManager.sharedManager.trySave(managedObject: managedObject)

            tableView.deleteRows(at: [indexPath], with: .fade)
        }   
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
           let reminder = reminders[indexPath.row]
           performSegue(withIdentifier: "toEditReminder", sender: reminder)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditReminder"{
            let destinationVC = segue.destination as! AddReminderVC
            destinationVC.reminderToChange = sender as? Reminder
     
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





