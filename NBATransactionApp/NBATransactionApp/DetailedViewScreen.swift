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
