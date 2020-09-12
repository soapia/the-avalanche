//
//  AddNewContactRepsViewController.swift
//  the avalanche
//
//  Created by Sofia Ongele on 9/8/20.
//  Copyright © 2020 Sofia Ongele. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class AddNewContactRepsViewController: UIViewController {
    var receivedData = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func addInfo() {
            let ref = Database.database().reference().child("actionItems")
            ref.observeSingleEvent(of: .value) { (snapshot) in
                for child in snapshot.children.allObjects as! [DataSnapshot] {
                    var toAdd = child.value as? [String: String] ?? [:]
                    print(toAdd)
                    if toAdd["name"] == self.receivedData {
                        
                    }
                }
            }
        }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
