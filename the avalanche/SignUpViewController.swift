//
//  SignUpViewController.swift
//  the avalanche
//
//  Created by Sofia Ongele on 8/28/20.
//  Copyright © 2020 Sofia Ongele. All rights reserved.
//

import UIKit

import Firebase
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    
    
    @IBAction func signUp(_ sender: Any) {
        if password.text != passwordConfirm.text {
            let alertController = UIAlertController(title: "Password Incorrect", message: "Please re-type password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
        }
        else {
            Auth.auth().createUser(withEmail: email.text!, password: password.text!){ (user, error) in
                if error == nil && self.valid() {
                    let userID = Auth.auth().currentUser?.uid
                    var ref : DatabaseReference!
                    ref = Database.database().reference().child("users").child(userID!).child("info")
                    let infoDict : [String : Any] = ["name" : self.name.text!, "zipCode" : self.zipCode.text]
                    ref.setValue(infoDict)
                    
                    
                    
                    
                    if let home = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController
                    {
                        home.modalPresentationStyle = .fullScreen
                        UIApplication.topViewController()?.present(home, animated: true, completion: nil)
                    }
                }
                else{
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordConfirm: UITextField!
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var zipCode: UITextField!
    
    func valid() -> Bool {
        var booly = true
        if (name.text!.isEmpty || zipCode.text!.isEmpty) {
            booly = false
        } else {
            // TODO: add alert
        }
        return booly
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        email.resignFirstResponder()
        password.resignFirstResponder()
        passwordConfirm.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        //or
        //self.view.endEditing(true)
        return true
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
