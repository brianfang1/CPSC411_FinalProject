//
//  HomeScreen.swift
//  NBATransactionApp
//
//  Created by csuftitan on 12/10/21.
//

import UIKit


class HomeScreen: UIViewController,  UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cnt = store.getAllTrades().count
        print("Number of trades to display: \(cnt)")
        return cnt
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create dateformatter to formate date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, YYYY, HH:mm:ss"
        
        let cell = tblView.dequeueReusableCell(withIdentifier: "TransactionSummaryCell", for: indexPath)
        let trades = store.getAllTrades()[indexPath.row]
        cell.textLabel?.text = dateFormatter.string(from: trades.transactionDate)
        cell.detailTextLabel?.text = "\(trades.team1!.teamName!)\t\(trades.team2!.teamName!)"
        return cell
    }

        // ADD THIS IF WE WANT TO DELETE FROM SUMMARY VIEW
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let row = indexPath.row
//            let student = store.getStudents()[row]
//            store.deleteStudent(sObj: student)
//            //
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//        }
//    }
    
    @IBOutlet var tblView : UITableView!
    let store = DataStore.get()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.dataSource = self
        tblView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tblView.reloadData()
    }
}