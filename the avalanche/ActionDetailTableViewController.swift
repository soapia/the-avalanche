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
    var item = [String: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(receivedData)
        self.title = "Take Action"
        addInfo()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func addInfo() {
            let ref = Database.database().reference().child("actionItems")
            ref.observeSingleEvent(of: .value) { (snapshot) in
                for child in snapshot.children.allObjects as! [DataSnapshot] {
                    var toAdd = child.value as? [String: String] ?? [:]
                    print(toAdd)
                    if toAdd["name"] == self.receivedData {
                        self.item = toAdd
                    }
                }
    //            DispatchQueue.main.async {
                    self.tableView.reloadData()
    //            }
            }
            refreshControl?.endRefreshing()
        }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "tldrCell", for: indexPath) as! TLDRTableViewCell
        
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath)
        
        let cell3 = tableView.dequeueReusableCell(withIdentifier: "learnCell", for: indexPath) as! LearnMoreTableViewCell
        
        if indexPath.row == 0 {
            cell1.desc.text = item["desc"]
            return cell1
        } else if indexPath.row == 2 {
            cell3.desc.text = item["desc"]
            return cell3
        } else {
            return cell2
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
