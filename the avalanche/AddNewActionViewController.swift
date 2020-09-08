//
//  AddNewActionViewController.swift
//  the avalanche
//
//  Created by Sofia Ongele on 9/7/20.
//  Copyright © 2020 Sofia Ongele. All rights reserved.
//

import UIKit

class AddNewActionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        myPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
     return myPickerData[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        actionType.text = myPickerData[row]
    }
    

    @IBOutlet weak var charCount: UILabel!
    @IBOutlet weak var myTitle: UITextField!
    @IBOutlet weak var desc: UITextView!
    @IBOutlet weak var shortDesc: UITextView!
    @IBOutlet weak var actionType: UITextField!
    
    
    let thePicker = UIPickerView()
    var myPickerData = ["Contacting Representatives", "Petitions + Misc"]
    override func viewDidLoad() {
        super.viewDidLoad()
        actionType.inputView = thePicker
        thePicker.delegate = self

        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func nextView(_ sender: Any) {
        allReady()
        if actionType.text == "Contacting Representatives" {
            self.performSegue(withIdentifier: "contactReps", sender: self)
        } else if actionType.text == "Petitions + Misc" {
            self.performSegue(withIdentifier: "petitions", sender: self)
        }
        print(actionType.text)
    }
    
    func allReady() -> Bool {
        var ready = false
        if (myTitle.text != "" && desc.text != "" && shortDesc.text != "" && actionType.text != "") {
            ready = true
        } else {
            let alert = UIAlertController(title: "hey!", message: "you must fill in all of the fields before continuing.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "okay, let me fix it!", style: .default, handler: nil))


            self.present(alert, animated: true)
        }
        return ready
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textView.text ?? ""
        
        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)

        // make sure the result is under 16 characters
        return updatedText.count <= 240
    }
    
//    func textViewDidChange(_ textView: UITextView) {
//        charCount.text = String(240 - currentText.count)
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
