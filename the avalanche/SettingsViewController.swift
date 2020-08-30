//
//  SettingsViewController.swift
//  the avalanche
//
//  Created by Sofia Ongele on 8/28/20.
//  Copyright © 2020 Sofia Ongele. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SettingsViewController: UIViewController {
    @IBAction func logOut(_ sender: UIButton) {
        do {
                   try Auth.auth().signOut()
               }
            catch let signOutError as NSError {
                   print ("Error signing out: %@", signOutError)
               }
               
               let storyboard = UIStoryboard(name: "Main", bundle: nil)
               let initial = storyboard.instantiateInitialViewController()
               UIApplication.shared.keyWindow?.rootViewController = initial
        print("hi")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
