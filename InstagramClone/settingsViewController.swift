//
//  settingsViewController.swift
//  InstagramClone
//
//  Created by Paweł Kamieński on 27/12/2021.
//

import UIKit
import Firebase

class settingsViewController: UIViewController {

    @IBAction func logoutClicked(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toViewController", sender: nil)
        } catch {
            print("Error")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
