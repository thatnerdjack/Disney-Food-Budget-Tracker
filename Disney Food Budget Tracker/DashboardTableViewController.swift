//
//  DashboardTableViewController.swift
//  Disney Food Budget Tracker
//
//  Created by Jack Doherty on 6/29/18.
//  Copyright © 2018 Jack Doherty. All rights reserved.
//

import UIKit
import FirebaseDatabase

class DashboardTableViewController: UITableViewController {
    
    var tripNamesAndIDs: Dictionary = [String:String]()
    var tripNamesAndInDates: Dictionary = [String:String]()
    var selectedTripID = ""
    
    let ref = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(self.backToInitial(sender:)))
        
        ref.child("trips").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            for key in value! {
                let tripIDString: String = key.key as! String
                let tripDetails = key.value as? NSDictionary
                let nameAsString: String = (tripDetails?["TRIP_NAME"] as! String)
                
                self.tripNamesAndIDs[nameAsString] = tripIDString
                self.tripNamesAndInDates[nameAsString] = (tripDetails?["CHECK_IN_DATE"] as! String)
            }
            self.tableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func backToInitial(sender: AnyObject) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func confirmTripDelete(tripName: String) {
        let alert = UIAlertController(title: "Are you sure you want to delete this trip?", message: "Type yes to confirm.", preferredStyle: .alert)
        
        let typeAction = UIAlertAction(title: "Enter confirmation", style: .destructive) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
        }
        alert.addTextField { (textField) in
            textField.placeholder = "WARNING: DELETE IS PERMENANT"
        }
        
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "Delete", style: .destructive) { (alertAction) in
            let confirmationText = alert.textFields![0].text
            if confirmationText?.lowercased() == "yes" {
                let tripID = self.tripNamesAndIDs[tripName]
                self.tripNamesAndIDs.remove(at: self.tripNamesAndIDs.index(forKey: tripName)!)
                self.tripNamesAndInDates.remove(at: self.tripNamesAndInDates.index(forKey: tripName)!)
                self.ref.child("trips/\(tripID!)").removeValue()
                self.tableView.reloadData()
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        
        self.present(alert, animated: true)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tripNamesAndIDs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath)
        let tripsArr = Array(tripNamesAndIDs)
        
        cell.textLabel?.text = tripsArr[indexPath.row].key
        cell.detailTextLabel?.text = tripNamesAndInDates[tripsArr[indexPath.row].key]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTripID = tripNamesAndIDs[(tableView.cellForRow(at: indexPath)?.textLabel?.text)!]!
        performSegue(withIdentifier: "dashboardToTrip", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            confirmTripDelete(tripName: (tableView.cellForRow(at: indexPath)?.textLabel?.text)!)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! TripViewController
        destination.tripID = selectedTripID
    }

}
