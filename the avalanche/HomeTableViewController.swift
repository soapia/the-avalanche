//
//  HomeTableViewController.swift
//  the avalanche
//
//  Created by Sofia Ongele on 8/28/20.
//  Copyright © 2020 Sofia Ongele. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class HomeTableViewController: UITableViewController {
    var items = [[String: String]]()
//    func handleRefresh(_ refreshControl: UIRefreshControl) {
//
//        addToArray()
//
//        refreshControl.endRefreshing()
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        addToArray()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(refreshItems), for: .valueChanged)
        self.refreshControl = refreshControl


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @objc func refreshItems() {
        items.removeAll()
        let ref = Database.database().reference().child("actionItems")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                var toAdd = child.value as? [String: String] ?? [:]
                if self.items.contains(toAdd) {
                    print("i'm already here!")
                } else {
                    self.items.append(toAdd)
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
        return items.count
    }
    
    func addToArray() {
        let ref = Database.database().reference().child("actionItems")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                var toAdd = child.value as? [String: String] ?? [:]
                if self.items.contains(toAdd) {
                    print("i'm already here!")
                } else {
                    self.items.append(toAdd)
                }
                
                
            }
//            DispatchQueue.main.async {
                self.tableView.reloadData()
//            }
        }
        refreshControl?.endRefreshing()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! ActionItemTableViewCell
        
        cell.title.text = items[indexPath.row]["name"]
        cell.desc.text = items[indexPath.row]["desc"]
        // Configure the cell...

        return cell
    }
    
    
    
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
