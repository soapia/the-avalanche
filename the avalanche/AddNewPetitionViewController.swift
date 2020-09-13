//
//  AddNewPetitionViewController.swift
//  the avalanche
//
//  Created by Sofia Ongele on 9/8/20.
//  Copyright © 2020 Sofia Ongele. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class AddNewPetitionViewController: UIViewController {
    var receivedData = ""
    var dataToAppend = [String: Any]()
    
    @IBOutlet weak var directions: UITextView!
    @IBOutlet weak var links: UITextField!
    @IBOutlet weak var mediaLinks: UITextField!
    var allGood = true
    @IBAction func submitButton(_ sender: Any) {
        if (directions.text != "" && links.text != "" && mediaLinks.text != "" && allGood) {
            dataToAppend = ["directions": directions.text!, "links": links.text!, "mediaLinks": mediaLinks.text!]
            addToDB()
            
        } else if (links.text != "" && mediaLinks.text != "" && allGood) {
            dataToAppend = ["links": links.text!, "mediaLinks": mediaLinks.text!]
            addToDB()
        } else if (links.text != "" && allGood) {
            dataToAppend = ["links": links.text!]
            addToDB()
        } else {
            let alert = UIAlertController(title: "hey!", message: "you must fill in all of the fields before continuing.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "okay, let me fix it!", style: .default, handler: nil))


            self.present(alert, animated: true)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("I WORKED I WORKED I WORKED")
        print(receivedData)
        // Do any additional setup after loading the view.
    }
    
    func addToDB() {
        let ref = Database.database().reference().child("actionItems")
        
        var childID = ""
        ref.observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let toAdd = child.value as? [String: Any] ?? [:]
                print(toAdd)
                if toAdd["name"]! as! String == self.receivedData {
                    ref.child(child.key).child("actions").setValue(self.dataToAppend)
                    
                    childID = child.key
                }
            }
        }

        
        for vc in (self.navigationController?.viewControllers ?? []) {
            if vc is HomeTableViewController {
                _ = self.navigationController?.popToViewController(vc, animated: true)
                break
            }
        }
    }
    
    func checkLinks(list: String) {
        let trimmedList = list.trimmingCharacters(in: .whitespacesAndNewlines)
        let linkArray = trimmedList.split{ $0 == "," }.map(String.init)
        for link in linkArray {
            if verifyUrl(urlString: link) {
                allGood = false
            }
        }
    }
    
    func verifyUrl(urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
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
