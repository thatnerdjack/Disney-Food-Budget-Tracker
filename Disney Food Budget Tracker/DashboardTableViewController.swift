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

    // MARK: - Table view data source

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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! TripViewController
        destination.tripID = selectedTripID
    }

}
