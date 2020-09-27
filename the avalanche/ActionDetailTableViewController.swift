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
import FirebaseAuth
import SafariServices
import CoreLocation


class ActionDetailTableViewController: UITableViewController {
    
    var receivedData: String = ""
    var item = [String: Any]()
    var actions = [String: String]()
    var phoneNumbers = [String]()
    var emails = [String]()
    var actionLinks = [String]()
    var learnLinks = [String]()
    
    var userName = ""
    var userCity = ""
    var userState = ""
    let geocoder = CLGeocoder()
    
    var numberOfRows = 2
    var phoneCount = 0
    var emailsIncluded = false
    var petitionCount = 0
    var actionNum = 0
    var learnCount = -1
    var tableArray = [String]()
    
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
    
    
    @IBAction func markAsCompleted(_ sender: Any) {
        
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
    
    func prepEmail() {
        if let emailText = actions["promptText"] {
            let userID = Auth.auth().currentUser?.uid
            var ref : DatabaseReference!
            ref = Database.database().reference().child("users").child(userID!).child("info")
            ref.observeSingleEvent(of: .value) { (snapshot) in
                let value = snapshot.value as? NSDictionary
                self.userName = value?["name"] as? String ?? ""
                let zip = value?["zipCode"] as? String ?? ""
                self.geocoder.geocodeAddressString(zip) {
                    (placemarks, error) -> Void in
                    // Placemarks is an optional array of CLPlacemarks, first item in array is best guess of Address
                    print(placemarks)
                    if let placemark = placemarks?[0] {

                        self.userCity = placemark.locality ?? ""
                        print(self.userCity)
                        self.userState = placemark.administrativeArea ?? ""
                        print(self.userState)
                        var place = "\(self.userCity), \(self.userState)"
                        var promptText = emailText.replacingOccurrences(of: "NAME", with: self.userName).replacingOccurrences(of: "CITY", with: "\(place)")
                        print(promptText)
                        // var myCharset = CharacterSet("#%&")
                        let urlPrompt = promptText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                        // let prompt = urlPrompt?.url
                            //
                        
                        let toWho = self.getEmailList()
                        let link = "mailto:\(toWho)?subject=EDIT%20ME&body=\(urlPrompt!)"
                        let unwrap = URLComponents(string: link)
                        let prompt = unwrap?.url
                        print(link)
                        if let url = prompt {
                          if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url)
                          } else {
                            UIApplication.shared.openURL(url)
                          }
                        }
                    }
                }
            }
        }
    }
    
    func zipToCity(zipCode: String) -> String {
        // var toReturn = ""
        geocoder.geocodeAddressString(zipCode) {
            (placemarks, error) -> Void in
            // Placemarks is an optional array of CLPlacemarks, first item in array is best guess of Address
            print(placemarks)
            if let placemark = placemarks?[0] {

                self.userCity = placemark.locality ?? ""
                print(self.userCity)
                self.userState = placemark.administrativeArea ?? ""
                print(self.userState)
            }

        }
        return "\(self.userCity), \(self.userState)"
    }
    
//    func linkReplace(link: String) -> String {
//        var newLink = URLComponents()
//    }
    
    func getEmailList() -> String {
        var emailString = ""
        for email in self.emails {
            emailString += email
            if email != emails.last {
               emailString += ","
            }
        }
        let toReturn = emailString.replacingOccurrences(of: " ", with: "")
        return toReturn
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
//            tableArray.append(item["shortDesc"] as! String)
            return cell1
        } else if indexPath.row == 1 {
            cell2.desc.text = actions["directions"]
//            tableArray.append(actions["directions"]!)
            return cell2
        } else if 2...actionNum+1 ~= indexPath.row {
            if emailsIncluded == false {
                cell3.actionTitle.text = "Send an Email"
                emailsIncluded = true
//                tableArray.append("Send an email")
                return cell3
            } else if phoneNumbers.count != 0 && phoneCount != phoneNumbers.count {
                cell3.actionTitle.text = phoneNumbers[phoneCount]
//                tableArray.append(phoneNumbers[phoneCount])
                phoneCount += 1
                return cell3
            } else if actionLinks.count != 0 && petitionCount != actionLinks.count {
                cell3.actionTitle.text = actionLinks[petitionCount]
//                tableArray.append(actionLinks[petitionCount])
                petitionCount += 1
                return cell3
            }
//            tableArray.append(cell3.actionTitle.text!)
        } else {
            if learnCount == -1 {
                learnCount += 1
                cell4.desc.text = item["desc"] as? String
//                tableArray.append(item["desc"] as! String)
                return cell4
            } else if learnLinks.count != 0 && learnCount != learnLinks.count {
                cell3.actionTitle.text = learnLinks[learnCount]
//                tableArray.append(learnLinks[learnCount])
                learnCount += 1
                return cell3
            }
        }

        // Configure the cell...

        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        if (cell?.isKind(of: TLDRTableViewCell.self))! {
            cell!.selectionStyle = .none
            print("im info")
        } else {
            // TO DO: MAKE BUTTONS PRESSABLE
            var fixCell = cell as! ActionButtonTableViewCell
            cell!.selectionStyle = .gray
            print("imma button")
            if fixCell.actionTitle.text! == "Send an Email" {
                print("let's email")
                prepEmail()
            } else if fixCell.actionTitle.text!.isValidPhone {
                print("let's call")
                let unwrapAndFlat = fixCell.actionTitle.text!.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "-", with: "")
                if let url = URL(string: "tel://1\(unwrapAndFlat)"),
                UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            } else {
                print("let's link")
                let unwrapAndFlat = fixCell.actionTitle.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                let url = (URL(string: unwrapAndFlat) ?? URL(string: "https://google.com"))!
                let svc = SFSafariViewController(url: url)
                present(svc, animated: true, completion: nil)
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
