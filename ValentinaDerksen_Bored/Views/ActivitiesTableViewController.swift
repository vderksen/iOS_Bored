// Student ID: 153803184
// Student name: Valentina Derksen
// https://github.com/vderksen/iOS_Bored

//  ActivitiesTableViewController.swift
//  ValentinaDerksen_Bored
//
//  Created by Valya Derksen on 2021-04-20.
//

import UIKit

class ActivitiesTableViewController: UITableViewController {
    
    // an array of added single orders
    private var activityList : [ActivityDB] = [ActivityDB]()
    private let dbHelper = DatabaseHelper.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // add title on the top of table view
        self.navigationItem.title = "Favorite Activities"
        self.fetchAllActivities()
    }
    
    private func fetchAllActivities(){
        if(self.dbHelper.getAllActivities() != nil){
            self.activityList = self.dbHelper.getAllActivities()!
            self.tableView.reloadData()
        }else {
            print(#function, "No data received from dbHelper")
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return activityList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ActivityCell
        
        // Configure the cell...
        if indexPath.row < activityList.count{
            let activity = activityList[indexPath.row]
            cell.lblActivity.text = activity.name
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = self.delete(forRowAtIndexPath: indexPath)
        //let edit = self.edit(forRowAtIndexPath: indexPath)
        //let swipe = UISwipeActionsConfiguration(actions: [delete, edit])
        let swipe = UISwipeActionsConfiguration(actions: [delete])
        return swipe
    }
    
    func delete(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
          // let order = orderList[indexPath.row]
           let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, _) in
              // Perform Delete Action
            if (indexPath.row < self.activityList.count){
                //ask for the confirmation first
                self.deleteOrderFromList(indexPath: indexPath)
            }
           }
           return action
       }
    
    private func deleteOrderFromList(indexPath: IndexPath){
        self.dbHelper.deleteActivity(activityID: self.activityList[indexPath.row].id!)
        self.fetchAllActivities()
    }
       
}
