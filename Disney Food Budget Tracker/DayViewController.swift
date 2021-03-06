//
//  DayViewController.swift
//  Disney Food Budget Tracker
//
//  Created by Jack Doherty on 7/1/18.
//  Copyright © 2018 Jack Doherty. All rights reserved.
//

import UIKit
import FirebaseDatabase

class DayViewController: UIViewController {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var breakfastLabel: UILabel!
    @IBOutlet weak var lunchLabel: UILabel!
    @IBOutlet weak var dinnerLabel: UILabel!
    @IBOutlet weak var snacksLabel: UILabel!
    
    var tripID: String!
    var dateString: String!
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dayLabel.text = dateString
        
        ref.child("trips/\(tripID!)/dates/\(dateString!)").observeSingleEvent(of: .value, with: { (snapshot) in
            let dayDetails = snapshot.value as? NSDictionary
            
            if let breakfastDetails = dayDetails!["Breakfast"] as? NSDictionary {
                var cost = 0.00
                for keys in breakfastDetails {
                    let values = keys.value as? NSDictionary
                    if let innerCost = values!["cost"] {
                        cost += innerCost as! Double
                    }
                }
                self.breakfastLabel.text = self.replaceDollarVal(s: self.breakfastLabel.text!, newDollarAmnt: cost)
            } else {
                self.breakfastLabel.text = self.replaceDollarVal(s: self.breakfastLabel.text!, newDollarAmnt: 0.0)
            }
            
            if let lunchDetails = dayDetails!["Lunch"] as? NSDictionary {
                var cost = 0.00
                for keys in lunchDetails {
                    let values = keys.value as? NSDictionary
                    if let innerCost = values!["cost"] {
                        cost += innerCost as! Double
                    }
                }
                self.lunchLabel.text = self.replaceDollarVal(s: self.lunchLabel.text!, newDollarAmnt: cost)
            } else {
                self.lunchLabel.text = self.replaceDollarVal(s: self.lunchLabel.text!, newDollarAmnt: 0.0)
            }
            
            if let dinnerDetails = dayDetails!["Dinner"] as? NSDictionary {
                var cost = 0.00
                for keys in dinnerDetails {
                    let values = keys.value as? NSDictionary
                    if let innerCost = values!["cost"] {
                        cost += innerCost as! Double
                    }
                }
                self.dinnerLabel.text = self.replaceDollarVal(s: self.dinnerLabel.text!, newDollarAmnt: cost)
            } else {
                self.dinnerLabel.text = self.replaceDollarVal(s: self.dinnerLabel.text!, newDollarAmnt: 0.0)
            }
            
            if let snacksDetails = dayDetails!["Snacks"] as? NSDictionary {
                var cost = 0.00
                for keys in snacksDetails {
                    let values = keys.value as? NSDictionary
                    if let innerCost = values!["cost"] {
                        cost += innerCost as! Double
                    }
                }
                self.snacksLabel.text = self.replaceDollarVal(s: self.snacksLabel.text!, newDollarAmnt: cost)
            } else {
                self.snacksLabel.text = self.replaceDollarVal(s: self.snacksLabel.text!, newDollarAmnt: 0.0)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addMealButton(_ sender: Any) {
        performSegue(withIdentifier: "dayToAddMeal", sender: self)
    }
    
    func replaceDollarVal(s: String, newDollarAmnt: Double) -> String {
        let mealString = s.split(separator: "$")[0]
        let dollarFormatted = String(format: "%.2f", newDollarAmnt)
        return "\(mealString)$\(dollarFormatted)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dayToAddMeal" {
            let destination = segue.destination as! AddMealViewController
            destination.datesArr = [dateString]
            destination.tripID = tripID
        }
    }

}
