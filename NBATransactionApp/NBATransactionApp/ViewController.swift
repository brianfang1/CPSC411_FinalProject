//
//  ViewController.swift
//  NBATransactionApp
//
//  Created by csuftitan on 12/7/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        var store = DataStore.get()
        
        // Loads database with team info and player info
        // ** ONLY RUN ONCE WHEN INITIALIZING DATABASE **
        // insertTeams(store: store)
        // insertPlayers(store: store)
    }


}

