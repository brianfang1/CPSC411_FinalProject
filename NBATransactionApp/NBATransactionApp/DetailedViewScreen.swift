//
//  DetailedViewScreen.swift
//  NBATransactionApp
//
//  Created by csuftitan on 12/12/21.
//

import Foundation
import UIKit

class DetailedViewScreen : UIViewController{
    @IBOutlet var tradeDate : UILabel!
    @IBOutlet var teamLabel_1 : UILabel!
    @IBOutlet var playersLabel_1 : UILabel!
    @IBOutlet var teamLabel_2 : UILabel!
    @IBOutlet var playersLabel_2 : UILabel!
    var trade : Trade!
    
    @IBAction func delBtnClicked(_ sender : UIButton) {
        // Use UIAlertController to ask user if he REALLY wants to delete
        let alertBox = UIAlertController(title: "Delete Trade", message: "Are you sure you want to delete?", preferredStyle: .alert)
        
        // Create delete button action handler
        let delete = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
            store.delTrade(tradeObj: self.trade)
            self.navigationController?.popViewController(animated: true)
        })
        
        // Create cancer button action handler
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Canceled delete action.")
        })
        
        // Add UIAlertActions to UIAlertController
        alertBox.addAction(delete)
        alertBox.addAction(cancel)
        
        self.present(alertBox, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Create dateformatter to formate date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, YYYY, HH:mm:ss"
        if trade != nil {
            tradeDate.text = dateFormatter.string(from: trade.transactionDate)
            teamLabel_1.text = trade.team1.teamName
            teamLabel_2.text = trade.team2.teamName
            playersLabel_1.text = playerNames_ArrayToString(trade.team1_players)
            playersLabel_2.text = playerNames_ArrayToString(trade.team2_players)
        }
    }
}
