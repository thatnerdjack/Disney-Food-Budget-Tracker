//
//  AddMealViewController.swift
//  Disney Food Budget Tracker
//
//  Created by Jack Doherty on 7/1/18.
//  Copyright © 2018 Jack Doherty. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import JGProgressHUD

class AddMealViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var mealField: UISegmentedControl!
    @IBOutlet weak var costField: UITextField!
    
    var datesArr: [String]!
    var pickerView: UIPickerView!
    var tripID: String!
    var dateString: String!
    var mealString: String!
    var receiptUuid: String!
    
    let ref = Database.database().reference()
    let storageRef = Storage.storage().reference()
    
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
            let cost = Double(self.costField.text!)
            let autoRef = ref.child("trips/\(tripID!)/dates/\(dateString!)/\(mealString!)").childByAutoId()
            autoRef.child("cost").setValue(cost)
            autoRef.child("receipt").setValue(receiptUuid)
            self.performSegue(withIdentifier: "addMealToDay", sender: self)
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
    
    @IBAction func addReceipt(_ sender: Any) {
        AttachmentHandler.shared.showAttachmentActionSheet(vc: self)
        AttachmentHandler.shared.imagePickedBlock = { (image) in
            self.receiptUuid = UUID().uuidString
            let receiptRef = self.storageRef.child("receipts/\(self.receiptUuid!).jpeg")
            let uploadTask = receiptRef.putData(UIImageJPEGRepresentation(image, 0.8)!)
            
            let hud = JGProgressHUD(style: .dark)
            hud?.textLabel.text = "Uploading"
            hud?.show(in: self.view)
            
            let _ = uploadTask.observe(.success, handler: { (snapshot) in
                hud?.dismiss()
            })
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addMealToDay" {
            let destination = segue.destination as! DayViewController
            destination.tripID = tripID
            destination.dateString = dateString
        }
    }

}
