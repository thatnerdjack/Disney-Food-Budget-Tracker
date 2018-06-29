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
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        checkInDateField.text = dateFormatter.string(from: datePicker.date)
        checkInDate = datePicker.date
    }

    @IBAction func hitDone(_ sender: Any) {
        performSegue(withIdentifier: "newToDashboard", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tripName = tripNameField.text!
        let numNights = Int(numNightsField.text!)!
        let budget = Int(foodBudgetField.text!)!
        
        let tripRef = ref.child("trips").childByAutoId()
        tripRef.child("TRIP_NAME").setValue(tripName)
        tripRef.child("TOTAL_BUDGET").setValue(budget*numNights)
        
        for i in 0..<numNights {
            let advancementNum = Double(86400 * i)
            let dateInSeconds = checkInDate.addingTimeInterval(advancementNum)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .none
            let dateString = dateFormatter.string(from: dateInSeconds)
            
            tripRef.child("dates/\(dateString)/DAY_BUDGET").setValue(budget)
            tripRef.child("dates/\(dateString)/Breakfast").setValue(0)
            tripRef.child("dates/\(dateString)/Lunch").setValue(0)
            tripRef.child("dates/\(dateString)/Dinner").setValue(0)
            tripRef.child("dates/\(dateString)/Snacks").setValue(0)
        }
    }

}
