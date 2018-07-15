//
//  MealDetailTableViewController.swift
//  Disney Food Budget Tracker
//
//  Created by Jack Doherty on 7/14/18.
//  Copyright © 2018 Jack Doherty. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class MealDetailTableViewController: UITableViewController {
    
    var tripID: String!
    var dateString: String!
    var mealString: String!
    var workingReceiptID: String!
    var mealsAndCosts: Dictionary = [String:Double]()
    var mealsAndReceiptIDs: Dictionary = [String:String]()
    
    let ref = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref.child("trips/\(tripID!)/dates/\(dateString)/\(mealString)").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            for keys in value! {
                let entryID = keys.key
                let cost = (keys.value as! NSDictionary)["cost"] as! Double
                let receipt = (keys.value as! NSDictionary)["receipt"] as? String ?? nil
                
                self.mealsAndCosts = [entryID as! String:cost]
                self.mealsAndReceiptIDs = [entryID as! String:receipt] as! Dictionary<String, String>
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mealsAndCosts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)
        let mealsAndCostsArr = Array(mealsAndCosts).sorted(by: <)
        
        cell.textLabel?.text = mealsAndCostsArr[indexPath.row].key
        cell.detailTextLabel?.text = String(format: "%.2f", mealsAndCostsArr[indexPath.row].value)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mealID = tableView.cellForRow(at: indexPath)?.textLabel?.text
        workingReceiptID = mealsAndReceiptIDs[mealID!]
        
        if workingReceiptID == nil {
            let alert = UIAlertController(title: "Error", message: "No Receipt Added for this entry", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okButton)
            alert.show(self, sender: nil)
        } else {
            performSegue(withIdentifier: "mealDetailToReceipt", sender: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            confirmTripDelete(tripName: (tableView.cellForRow(at: indexPath)?.textLabel?.text)!)
        }
    }
    
    func confirmTripDelete(entryID: String) {
        let alert = UIAlertController(title: "Please confirm.", message: "Are you sure you want to delete this entry?", preferredStyle: .alert)
        
        //need ok and delete and then execute action
        mealsAndCosts.remove(at: mealsAndCosts.index(forKey: entryID))
        mealsAndReceiptIDs.remove(at: mealsAndReceiptIDs.index(forKey: entryID))
        ref.child("trips/\(tripID!)/dates/\(mealString!)/\(entryID)").removeValue()
        self.tableView.reloadData()
    }
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        
        self.present(alert, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mealDeatilToReceipt" {
            let dest = segue.destination
            dest.receiptID = workingReceiptID
        }
    }

}
