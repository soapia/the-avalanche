//
//  AddNewPetitionViewController.swift
//  the avalanche
//
//  Created by Sofia Ongele on 9/8/20.
//  Copyright © 2020 Sofia Ongele. All rights reserved.
//

import UIKit

class AddNewPetitionViewController: UIViewController {
    var receivedData = ""
    @IBOutlet weak var participationType: UITextField!
    @IBOutlet weak var directions: UITextView!
    @IBOutlet weak var links: UITextField!
    @IBOutlet weak var mediaLinks: UITextField!
    @IBAction func submitButton(_ sender: Any) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func checkLinks(list: String) -> [String] {
        var trimmedList = list.trimmingCharacters(in: .whitespacesAndNewlines)
        var linkArray = list.split{ $0 == "," }.map(String.init)
        for link in linkArray {
            
        }
        return linkArray
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
