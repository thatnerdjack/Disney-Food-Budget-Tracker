//
//  ReceiptViewController.swift
//  Disney Food Budget Tracker
//
//  Created by Jack Doherty on 7/15/18.
//  Copyright © 2018 Jack Doherty. All rights reserved.
//

import UIKit
import FirebaseStorage
import JGProgressHUD

class ReceiptViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var receiptID: String!
    let hud = JGProgressHUD(style: .dark)
    
    let storageRef = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hud?.textLabel.text = "Downloading"
        hud?.show(in: view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let downloadTask = storageRef.child("receipts/\(receiptID)").getData(maxSize: Int64.max) { (data, error) in
            self.imageView.image = UIImage(data: data!)
        }
        
        downloadTask.observe(.success) { (snapshot) in
            self.hud?.dismiss()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
