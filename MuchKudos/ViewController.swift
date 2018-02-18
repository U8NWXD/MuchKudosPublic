//
//  ViewController.swift
//  MuchKudos
//
//  Created by cs on 2/17/18.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var sendKudos_recipient: UITextField!
    @IBOutlet weak var sendKudos_body: UITextView!
    @IBOutlet weak var sendKudos_submit: UIButton!
    @IBOutlet weak var sendKudos_cancel: UIButton!
    @IBOutlet weak var sendKudos_viewAll: UIButton!
    var handle: AuthStateDidChangeListenerHandle!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SOURCE: https://stackoverflow.com/questions/32281651/how-to-dismiss-keyboard-when-touching-anywhere-outside-uitextfield-in-swift
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = true
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // TODO: Handle errors
        }
        ref = Database.database().reference()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    // SOURCE: https://stackoverflow.com/questions/32281651/how-to-dismiss-keyboard-when-touching-anywhere-outside-uitextfield-in-swift
    @objc func tap(gesture: UITapGestureRecognizer) {
        sendKudos_body.resignFirstResponder()
    }
    
    @IBAction func submitTapped(_ sender: UIButton) {
        let body: String! = sendKudos_body.text
        let recipient: String! = sendKudos_recipient.text
        
        let newKudos: DatabaseReference = ref.child("kudos").childByAutoId()
        
        newKudos.child("body").setValue(body)
        newKudos.child("recipient").setValue(recipient)
        
        let timeInterval = NSDate().timeIntervalSince1970
        newKudos.child("timestamp").setValue(timeInterval)
        clearAllFields()
        let queryResult = ref.child("users").queryOrdered(byChild: "name").queryEqual(toValue: recipient)
        queryResult.observeSingleEvent(of: .childAdded, with: { (snapshot) in
            snapshot.ref.child("received").child(newKudos.key).setValue(true)
        })
    }
    
    /* Clear the text box when pressing "clear" */
    @IBAction func cancelTapped(_ sender: UIButton) {
        clearAllFields()
    }
    
    @IBAction func viewAllTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sendKudosView = storyboard.instantiateViewController(withIdentifier: "viewAll") as UIViewController
        self.navigationController!.pushViewController(sendKudosView, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func clearAllFields() {
        // SOURCE: https://stackoverflow.com/questions/37084537/how-to-clear-text-field
        sendKudos_body.text = ""
        sendKudos_recipient.text = ""
    }
}
