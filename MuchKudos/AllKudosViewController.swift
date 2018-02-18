//
//  AllKudosViewController.swift
//  MuchKudos
//
//  Created by cs on 2/18/18.
//

import UIKit
import Firebase

class AllKudosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var viewAll_table: UITableView!
    var handle: AuthStateDidChangeListenerHandle!
    var ref: DatabaseReference!
    var numKudos: Int!
    var kudosData: [Kudos]!
    
    let cellReuseIdentifier = "cell"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print ("viewWillAppear")
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print ("numRows")
        print (kudosData!.count)
        return kudosData!.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.viewAll_table.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        // set the text from the data model
        cell.textLabel?.text = self.kudosData![indexPath.row].toString()
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print ("viewDidLoad")
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // TODO: Handle errors
        }
        ref = Database.database().reference()
        self.kudosData = []
        let queryResult = ref.child("kudos").queryOrdered(byChild: "timestamp")
        queryResult.observeSingleEvent(of: .value, with: { (snapshot) in
            // SOURCE: https://github.com/oliviabrown9/PoosCabooseGame/blob/master/KittyJump/LeaderboardViewController.swift
            print (snapshot)
            self.numKudos = 0
            print (snapshot.childrenCount)
            for snap in snapshot.children.allObjects as! [DataSnapshot] {
                self.numKudos! += 1
                let body: String = snap.childSnapshot(forPath: "body").value as! String
                let recipient: String = snap.childSnapshot(forPath: "recipient").value as! String
                let unixTimeStamp: NSNumber = snap.childSnapshot(forPath: "timestamp").value as! NSNumber
                
                print (body)
                print (recipient)
                print (unixTimeStamp)
                print ("=====")
                
                let kudos = Kudos(recipient: recipient, body: body, timestamp: unixTimeStamp)
                self.kudosData.append(kudos)
                print (self.kudosData.count)
            }
            
            // Register the table view cell class and its reuse id
            self.viewAll_table.register(UITableViewCell.self, forCellReuseIdentifier: self.cellReuseIdentifier)
            
            // (optional) include this line if you want to remove the extra empty cell divider lines
            // self.tableView.tableFooterView = UIView()
            
            // This view controller itself will provide the delegate methods and row data for the table view.
            self.viewAll_table.delegate = self as UITableViewDelegate
            self.viewAll_table.dataSource = self as UITableViewDataSource
            
            // Along with auto layout, these are the keys for enabling variable cell height
            self.viewAll_table.estimatedRowHeight = 176.0
            self.viewAll_table.rowHeight = UITableViewAutomaticDimension
            
            self.viewAll_table.reloadData()
        })
        
        print ("Finished")
        print (self.kudosData.count)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
