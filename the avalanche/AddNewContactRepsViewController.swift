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
    @IBOutlet weak var promptText: UITextView!
    @IBOutlet weak var directions: UITextView!
    @IBOutlet weak var emails: UITextField!
    @IBOutlet weak var phoneNumbers: UITextField!
    @IBOutlet weak var petitionLinks: UITextField!
    @IBOutlet weak var mediaLinks: UITextField!
    
    @IBAction func submitButton(_ sender: Any) {
        phoneAllGood = true
        linkAllGood = true
        emailAllGood = true
        checkItAll()
        if phoneAllGood && linkAllGood && emailAllGood {
            if phoneNumbers.text != "" || emails.text != "" {
                if promptText.text != "" {
                    addThingsToDict()
                    addToDB()
                } else {
                    // alert needing prompt text
                    let alert = UIAlertController(title: "hey!", message: "you must enter a prompt  before continuing.", preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "okay, let me fix it!", style: .default, handler: nil))


                    self.present(alert, animated: true)
                }
            } else {
                // alert for neither phone nor email
                let alert = UIAlertController(title: "hey!", message: "you must fill in either phone numbers or email addressed to contact before continuing.", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "okay, let me fix it!", style: .default, handler: nil))


                self.present(alert, animated: true)
            }
        } else {
            var toFormat = ["phone number": phoneAllGood, "link": linkAllGood, "email": emailAllGood]
            var alertString = "your formatting is incorrect for the following fields:\n"
            for (key, value) in toFormat {
                if !value {
                    alertString += "\(key)(s)\n"
                }
            }
            alertString += "please review your entries and try again"
            // alert here
            let alert = UIAlertController(title: "hey!", message: alertString, preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "okay, let me fix it!", style: .default, handler: nil))


            self.present(alert, animated: true)
        }
    }
    
    var dataToAppend = [String: Any]()
    var phoneAllGood = true
    var linkAllGood = true
    var emailAllGood = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
                linkAllGood = false
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
    
    func checkPhones(list: String) {
        let trimmedList = list.trimmingCharacters(in: .whitespacesAndNewlines)
        let phoneArray = trimmedList.split{ $0 == "," }.map(String.init)
        for phone in phoneArray {
            if !phone.isValidPhone {
                phoneAllGood = false
            }
        }
    }
    
    func checkEmails(list: String) {
        let trimmedList = list.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailArray = trimmedList.split{ $0 == "," }.map(String.init)
        for email in emailArray {
            if !email.isValidEmail {
                emailAllGood = false
            }
        }
    }
    
    func checkItAll() {
        if emails.text != nil {
            checkEmails(list: emails.text!)
        }
        
        if phoneNumbers.text != nil {
            checkPhones(list: phoneNumbers.text!)
        }
        
        if mediaLinks.text != nil {
            checkLinks(list: mediaLinks.text!)
        }
        
        if petitionLinks.text != nil {
            checkLinks(list: petitionLinks.text!)
        }
    }
    
    func addThingsToDict() {
        let dict = ["promptText": promptText.text, "directions": directions.text, "emails": emails.text, "phones": phoneNumbers.text, "links": petitionLinks.text, "mediaLinks": mediaLinks.text]
        
        for (key, value) in dict {
            if value != nil {
                dataToAppend[key] = value!
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

extension String {
   var isValidEmail: Bool {
      let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
      let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
      return testEmail.evaluate(with: self)
   }
   var isValidPhone: Bool {
      let regularExpressionForPhone = "^\\d{3}-\\d{3}-\\d{4}$"
      let testPhone = NSPredicate(format:"SELF MATCHES %@", regularExpressionForPhone)
      return testPhone.evaluate(with: self)
   }
}
