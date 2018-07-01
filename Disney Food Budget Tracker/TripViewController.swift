//
//  TripViewController.swift
//  Disney Food Budget Tracker
//
//  Created by Jack Doherty on 6/29/18.
//  Copyright © 2018 Jack Doherty. All rights reserved.
//

import UIKit
import FirebaseDatabase

class TripViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalRemainingLabel: UILabel!
    
    var tripID: String!    
    var nightCount = 0
    var datesAndBudgets: Dictionary = [String:Int]()
    var checkInDate: String!
    
    var ref = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()

        ref.child("trips/\(tripID!)").observeSingleEvent(of: .value, with: { (snapshot) in
            let tripDetails = snapshot.value as! NSDictionary
            self.titleLabel.text = tripDetails["TRIP_NAME"] as? String
            let dates = tripDetails["dates"] as! NSDictionary
            self.nightCount = dates.count
            self.checkInDate = tripDetails["CHECK_IN_DATE"] as? String
            
            for days in dates {
                let dayName = days.key as! String
                let dayDetails = days.value as? NSDictionary
                var budget = dayDetails!["DAY_BUDGET"] as? Int
                
                let breakfastCost = dayDetails!["Breakfast"] as? Int
                let lunchCost = dayDetails!["Lunch"] as? Int
                let dinnerCost = dayDetails!["Dinner"] as? Int
                let snacksCost = dayDetails!["Snacks"] as? Int
                
                budget = budget! - breakfastCost! - lunchCost! - dinnerCost! - snacksCost!
                
                self.datesAndBudgets[dayName] = budget
            }
            
            var moneyRemaining = 0
            for days in self.datesAndBudgets {
                moneyRemaining += days.value
            }
            self.totalRemainingLabel.text = "Total Remaining: $\(String(moneyRemaining))"
            
            self.tableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath)
        let datesAndBudgetsArr = Array(datesAndBudgets).sorted(by: <)
        
        cell.textLabel?.text = datesAndBudgetsArr[indexPath.row].key
        cell.detailTextLabel?.text = String(datesAndBudgetsArr[indexPath.row].value)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nightCount
    }
    
    @IBAction func addMealButton(_ sender: Any) {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        let dateAsString = dateFormatter.string(from: date)
        
        if dateAsString > checkInDate {     //swap > to < after testing!!
            let alert = UIAlertController(title: "It's too early!", message: "Wait until you get there before putting meals in.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else {
            //performSegue
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
