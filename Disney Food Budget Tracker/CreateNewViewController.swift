//
//  CreateNewViewController.swift
//  Disney Food Budget Tracker
//
//  Created by Jack Doherty on 6/27/18.
//  Copyright © 2018 Jack Doherty. All rights reserved.
//

import UIKit
import Firebase

class CreateNewViewController: UIViewController {
    
    @IBOutlet weak var tripNameField: UITextField!
    @IBOutlet weak var checkInDateField: UITextField!
    @IBOutlet weak var numNightsField: UITextField!
    @IBOutlet weak var foodBudgetField: UITextField!
    
    var checkInDate = Date.distantPast
    
    var ref : DatabaseReference! = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func checkInDateFieldEdit(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(checkInDatePickerChanged(datePicker:)), for: .valueChanged)
    }
    
    @objc func checkInDatePickerChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        checkInDateField.text = dateFormatter.string(from: datePicker.date)
    }

    @IBAction func hitDone(_ sender: Any) {
        performSegue(withIdentifier: "newToDashboard", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var tripName = tripNameField.text
        var checkInDateString = checkInDateField.text
        var numNights = Int(numNightsField.text!)!
        var budget = Int(foodBudgetField.text!)
        
        var tripRef = ref.child("trips/\(tripName)")
        
        for i in 0..<numNights {
            var dateInSeconds = checkInDate.addingTimeInterval(86400)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            var dateString = dateFormatter.string(from: dateInSeconds)
            
            tripRef.child(dateString).setValue(-1)
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
