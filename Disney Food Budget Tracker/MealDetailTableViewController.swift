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

//    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
