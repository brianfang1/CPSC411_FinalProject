//
//  ViewController.swift
//  NBATransactionApp
//
//  Created by csuftitan on 12/7/21.
//

import UIKit

class CellClass: UITableViewCell{
    
}
class ViewController: UIViewController {
    @IBOutlet weak var btnSelectTeam: UIButton!
    @IBOutlet weak var btnSelectPlayer: UIButton!
    var selectedTeam: Team!
    let transparentView = UIView()
    let tableView = UITableView()
    
    var selectedButton = UIButton()
    var dataSource = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
        // Do any additional setup after loading the view.
        var store = DataStore.get()
        
        // Loads database with team info and player info
        // ** ONLY RUN ONCE WHEN INITIALIZING DATABASE **
         //insertTeams(store: store)
         //insertPlayers(store: store)
        
        
        /* TEST Trading
           This trades:
            Lakers(teamId=1):
                Carmelo Anthony(playerId=1),
                Trevor Ariza(playerId=2)
            Clippers(teamId=2):
                Ivica Zubac(playerId=33)
         ** ONLY RUN AFTER INSERTING TEAMS AND PLAYERS **
        */
//        let tradeObj =  Trade(Team("Lakers", 1)!, Team("Clippers", 2)!, [Player(1, "Carmelo", "Anthony", 1)!, Player(2, "Trevor", "Ariza", 1)!], [Player(34, "Ivica", "Zubac", 2)!], date: Date.now)
//        store.createTrade(tradeObj: tradeObj)
        
        //Trade back
//        let tradeObj2 =  Trade(Team("Clippers", 2)!, Team("Lakers", 1)!, [Player(1, "Carmelo", "Anthony", 1)!, Player(2, "Trevor", "Ariza", 1)!], [Player(34, "Ivica", "Zubac", 2)!], date: Date.now)
//        store.createTrade(tradeObj: tradeObj2)
        
        
    }
    func addTransparentView(frames : CGRect) {
        let window = UIApplication.shared.keyWindow
        transparentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView)
        
        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        self.view.addSubview(tableView)
        tableView.layer.cornerRadius = 5
        
        transparentView.backgroundColor=UIColor.black.withAlphaComponent(0.9)
        tableView.reloadData()
        
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapgesture)
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0,initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: { [self] in
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(self.dataSource.count * 50))
        }, completion: nil)
    }
    
    @objc func removeTransparentView(){
        let frames = selectedButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0,initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        }, completion: nil)
    }
    
    
    @IBAction func onClickSelectTeam(_ sender: Any) {
        let Teams = store.getAllTeams()
        var teamNames = [String]()
        for team in Teams {
            teamNames.append(team.teamName)
        }
        
        dataSource = teamNames
        selectedButton = btnSelectTeam
        addTransparentView(frames: btnSelectTeam.frame)
    }
    
    @IBAction func onClickSelectPlayer(_ sender: Any) {
        dataSource = ["Paul George", "Carmelo Anthony"]
        selectedButton = btnSelectPlayer
        addTransparentView(frames: btnSelectPlayer.frame)
    }
    

}

extension ViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedButton.setTitle(dataSource[indexPath.row], for: .normal)
        removeTransparentView()
    }
}
