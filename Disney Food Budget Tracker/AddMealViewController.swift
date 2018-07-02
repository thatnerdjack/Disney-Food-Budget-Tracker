//
//  AddMealViewController.swift
//  Disney Food Budget Tracker
//
//  Created by Jack Doherty on 7/1/18.
//  Copyright © 2018 Jack Doherty. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddMealViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var mealField: UISegmentedControl!
    @IBOutlet weak var costField: UITextField!
    
    var datesArr: [String]!
    var pickerView: UIPickerView!
    var tripID: String!
    var dateString: String!
    var mealString: String!
    
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("datesArr: \(datesArr!)")
        
        setuoPickerView()
        dateField.inputView = pickerView
        
        if datesArr.count == 1 {
            dateField.text = datesArr[0]
            dateField.isEnabled = false
            dateString = datesArr[0]
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setuoPickerView() {
        pickerView = UIPickerView()
        pickerView.delegate = self
        
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneClick))
        
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        dateField.inputAccessoryView = toolbar
    }
    
    @objc func doneClick() {
        dateField.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return datesArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return datesArr[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dateField.text = datesArr[row]
    }
    
    @IBAction func hitDone(_ sender: Any) {
        if checkForErrors() {
            return
        } else {
            ref.child("trips/\(tripID)/dates/\(dateString)/\(mealString)").runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
                var currentSpent = currentData.value as? Double
                let costDouble = Double(self.costField.text!)
                
                currentSpent = costDouble
                currentData.value = currentSpent
                
                return TransactionResult.success(withValue: currentData)
                //WHAT DOES THE OUTEWR BLOCK DOO???????????????????
            }) { (error, committed, snapshot) in
                <#code#>
            }
        }
    }
    
    func checkForErrors() -> Bool {
        let alert = UIAlertController(title: "Error in meal details", message: "You need to fill out all fields!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        if dateField.text == nil {
            print("fail datefield")
            self.present(alert, animated: true)
            return true
        }
        
        if mealField.selectedSegmentIndex == -1 {
            self.present(alert, animated: true)
            return true
        } else {
            mealString = mealField.titleForSegment(at: mealField.selectedSegmentIndex)
        }
        
        if costField.text == nil {
            self.present(alert, animated: true)
            return true
        }
        return false
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
