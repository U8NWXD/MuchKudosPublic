//
//  LoginViewController.swift
//  MuchKudos
//
//  Created by cs on 2/17/18.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var login_username: UITextField!
    @IBOutlet weak var login_password: UITextField!
    @IBOutlet weak var login_signIn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // SOURCE: https://stackoverflow.com/questions/32281651/how-to-dismiss-keyboard-when-touching-anywhere-outside-uitextfield-in-swift
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    // SOURCE: https://stackoverflow.com/questions/32281651/how-to-dismiss-keyboard-when-touching-anywhere-outside-uitextfield-in-swift
    @objc func tap(gesture: UITapGestureRecognizer) {
        login_username.resignFirstResponder()
        login_password.resignFirstResponder()
    }
    
    @IBAction func onSignInClick(_ sender: UIButton) {
        let username: String = login_username.text!
        let password: String = login_password.text!
        
        Auth.auth().signIn(withEmail: username, password: password) { (user, error) in
            if error != nil {
                print ("Authentication Failed")
                return
            } else {
                print ("Authentication Successful")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let sendKudosView = storyboard.instantiateViewController(withIdentifier: "sendKudos") as UIViewController
                self.navigationController!.pushViewController(sendKudosView, animated: false)
                return
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
