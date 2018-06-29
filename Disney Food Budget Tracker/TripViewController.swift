//
//  TripViewController.swift
//  Disney Food Budget Tracker
//
//  Created by Jack Doherty on 6/29/18.
//  Copyright © 2018 Jack Doherty. All rights reserved.
//

import UIKit
import FirebaseDatabase

class TripViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var tripID: String!
    
    var ref = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()

        ref.child("trips/\(tripID)").observeSingleEvent(of: .value, with: { (snapshot) in
            let tripDetails = snapshot.value as? NSDictionary
            //populate table view with days
        }) { (error) in
            print(error.localizedDescription)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
