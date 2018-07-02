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
    
    var checkInDate: Date!
    var checkInDateString: String!
    
    var ref : DatabaseReference! = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpToolbar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpToolbar() {
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneClick))
        
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        tripNameField.inputAccessoryView = toolbar
        checkInDateField.inputAccessoryView = toolbar
        numNightsField.inputAccessoryView = toolbar
        foodBudgetField.inputAccessoryView = toolbar
    }
    
    @objc func doneClick() {
        tripNameField.resignFirstResponder()
        checkInDateField.resignFirstResponder()
        numNightsField.resignFirstResponder()
        foodBudgetField.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y = 0
            }
        }
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
        checkInDateString = dateFormatter.string(from: datePicker.date)
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
        tripRef.child("CHECK_IN_DATE").setValue(checkInDateString)
        
        for i in 0..<numNights {
            let advancementNum = Double(86400 * i)
            let dateInSeconds = checkInDate.addingTimeInterval(advancementNum)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .none
            let dateString = dateFormatter.string(from: dateInSeconds)
            
            tripRef.child("dates/\(dateString)/DAY_BUDGET").setValue(budget)
            tripRef.child("dates/\(dateString)/Breakfast").setValue(0.00)
            tripRef.child("dates/\(dateString)/Lunch").setValue(0.00)
            tripRef.child("dates/\(dateString)/Dinner").setValue(0.00)
            tripRef.child("dates/\(dateString)/Snacks").setValue(0.00)
        }
    }

}
