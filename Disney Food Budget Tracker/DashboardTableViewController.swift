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
    
    var trips: Dictionary = [String:String]()
    let ref = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref.child("trips").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            for key in value! {
                print(key.key)
                print(key.value)
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
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath)
        
        //pull array of /trips to get array of trips
        //use indexPath.row to call the correct date

        return cell
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
