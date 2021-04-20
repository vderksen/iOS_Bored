// Student ID: 153803184
// Student name: Valentina Derksen
// https://github.com/vderksen/iOS_Bored

//  ViewController.swift
//  ValentinaDerksen_Bored
//
//  Created by Valya Derksen on 2021-04-20.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    @IBOutlet var activity : UILabel!
    
    private let activityFetcher = ActivityFetcher.getInstance()
    private var activityInfo : Activity = Activity()
    
    private var cancellables: Set<AnyCancellable> = []
    
    // an array of added single activities
    private var activityList : [ActivityDB] = [ActivityDB]()
    private let dbHelper = DatabaseHelper.getInstance()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.activity.numberOfLines = 0 // to have multiple lines of text inside the Label
        self.activity.text = "\(self.activityInfo.activity)"
    }
    
    @IBAction func newActivity(){
        self.activityFetcher.fetchDataFromAPI()
        self.receiveChanges()
    }
    
    private func receiveChanges(){
        self.activityFetcher.$activityInfo.receive(on: RunLoop.main)
            .sink { (new) in
                print(#function, "Received activity: ", new)
                self.activityInfo = new
                self.viewDidLoad()
            }
            .store(in : &cancellables)
    }
    
    @IBAction func saveActivity(){
        var activityName : String = ""
        
        if (activity.text != "") {
            activityName = String(activity.text!) ?? " "
            
            let newActivity = SavedActivity(name: activityName)
            self.dbHelper.insertActivity(activity: newActivity)
        }
    }
    
    
    // set up segue Navigation to ActivitiesTableViewController
    @IBAction func viewSavedActivities(_sender: Any){
        performSegue(withIdentifier: "segueAllActivities", sender: self)
    }


}

