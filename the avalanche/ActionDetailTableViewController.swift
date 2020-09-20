//
//  ActionDetailTableViewController.swift
//  the avalanche
//
//  Created by Sofia Ongele on 9/5/20.
//  Copyright © 2020 Sofia Ongele. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ActionDetailTableViewController: UITableViewController {
    
    var receivedData: String = ""
    var item = [String: Any]()
    var actions = [String: String]()
    var phoneNumbers = [String]()
    var emails = [String]()
    var actionLinks = [String]()
    var learnLinks = [String]()
    
    
    var numberOfRows = 2
    var phoneCount = 0
    var emailsIncluded = false
    var petitionCount = 0
    var actionNum = 0
    var learnCount = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(receivedData)
        self.title = "Take Action"
        addInfo()
//        addActions()
        print(item)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func addInfo() {
        let ref = Database.database().reference().child("actionItems")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                var toAdd = child.value as? [String: Any] ?? [:]
                // print(toAdd)
                if toAdd["name"]! as! String == self.receivedData {
                    self.item = toAdd
                    self.actions = toAdd["actions"] as! [String : String]
//                    self.actions
                    print(self.actions)
                    print("HEY HEY HEY LOOK AT ME")
                    print(self.item)
                    self.addActions()
                }
            }
//            DispatchQueue.main.async {
                self.tableView.reloadData()
//            }
        }
        refreshControl?.endRefreshing()
    }
    
    func addActions() {
//        actions = item["actions"] as! [String : String]
        print("ACTION TYPE")
        print(item["actionType"])
        if item["actionType"] as? String == "Contacting Representatives" {
            // add emails to array
            if actions["emails"] != nil {
                let trimmedList = actions["emails"]!.trimmingCharacters(in: .whitespacesAndNewlines)
                emails = trimmedList.split{ $0 == "," }.map(String.init)
            }
            print("THE EMAILS")
            print(emails)
            // add phones to array
            if actions["phones"] != nil {
                var trimmedList = actions["phones"]!.trimmingCharacters(in: .whitespacesAndNewlines)
                trimmedList = trimmedList.trimmingCharacters(in: ["-"])
                phoneNumbers = trimmedList.split{ $0 == "," }.map(String.init)
            }
            print("THE PHONES")
            print(phoneNumbers)
            // add action links to array
            if actions["links"] != nil {
                let trimmedList = actions["links"]!.trimmingCharacters(in: .whitespacesAndNewlines)
                actionLinks = trimmedList.split{ $0 == "," }.map(String.init)
            }
            print("THE LINKS")
            print(actionLinks)
            // add learn links to array
            if actions["mediaLinks"] != nil {
                let trimmedList = actions["mediaLinks"]!.trimmingCharacters(in: .whitespacesAndNewlines)
                learnLinks = trimmedList.split{ $0 == "," }.map(String.init)
            }
            print("THE LEARN")
            print(learnLinks)
            // SOON: paraphrase text in prompt
            
            // HERE!! IT ME!!
            
        } else if item["actionType"] as? String == "Petitions" {
            // add action links to array
            if actions["links"] != nil {
                let trimmedList = actions["links"]!.trimmingCharacters(in: .whitespacesAndNewlines)
                actionLinks = trimmedList.split{ $0 == "," }.map(String.init)
            }
            print("THE LINKS")
            print(actionLinks)
            // add learn links to array
            if actions["mediaLinks"] != nil {
                let trimmedList = actions["mediaLinks"]!.trimmingCharacters(in: .whitespacesAndNewlines)
                learnLinks = trimmedList.split{ $0 == "," }.map(String.init)
            }
            print("THE LEARN")
            print(learnLinks)
        }
    }
    
    
    


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        numberOfRows += phoneNumbers.count + actionLinks.count
        if learnLinks.isEmpty == false {
            numberOfRows += 1 + learnLinks.count
        }
        if emails.isEmpty == false {
            numberOfRows += 1
            actionNum += 1
        }
        
        actionNum += phoneNumbers.count + actionLinks.count
        
        
        // #warning Incomplete implementation, return the number of rows
        return numberOfRows
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "tldrCell", for: indexPath) as! TLDRTableViewCell
        
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "takeActionCell", for: indexPath) as! TLDRTableViewCell
        
        let cell3 = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath) as! ActionButtonTableViewCell
        
        let cell4 = tableView.dequeueReusableCell(withIdentifier: "learnCell", for: indexPath) as! TLDRTableViewCell
        
        
        
        if indexPath.row == 0 {
            cell1.desc.text = item["shortDesc"] as? String
            return cell1
        } else if indexPath.row == 1 {
            cell2.desc.text = actions["directions"]
            return cell2
        } else if 2...actionNum+2 ~= indexPath.row {
            if emailsIncluded == false {
                cell3.actionTitle.text = "Send an email"
                emailsIncluded = true
                return cell3
            } else if phoneNumbers.count != 0 && phoneCount != phoneNumbers.count {
                cell3.actionTitle.text = phoneNumbers[phoneCount]
                phoneCount += 1
                return cell3
            } else if actionLinks.count != 0 && petitionCount != actionLinks.count {
                cell3.actionTitle.text = actionLinks[petitionCount]
                petitionCount += 1
                return cell3
            }
        } else {
            if learnCount == -1 {
                learnCount += 1
                cell4.desc.text = item["desc"] as? String
                return cell4
            } else if learnLinks.count != 0 && learnCount != learnLinks.count {
                cell3.actionTitle.text = learnLinks[learnCount]
                learnCount += 1
                return cell3
            }
        }

        // Configure the cell...

        return UITableViewCell()
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
