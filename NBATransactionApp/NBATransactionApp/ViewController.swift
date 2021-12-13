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
    @IBOutlet weak var btnSelectTeam1: UIButton!
    @IBOutlet weak var btnSelectPlayer1: UIButton!
    @IBOutlet weak var btnSelectTeam2: UIButton!
    @IBOutlet weak var btnSelectPlayer2: UIButton!
    let transparentView = UIView()
    let tableView = UITableView()
    var team1: Team!
    var team2: Team!
    var team1_playersList = [Player]()
    var team2_playersList = [Player]()
    var player1 = [Player]()
    var player2 = [Player]()
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
        // Also tests trading
//        // ** ONLY RUN ONCE WHEN INITIALIZING DATABASE **
//         insertTeams(store: store)
//         insertPlayers(store: store)
//         insertTransactions(store: store)

        
        
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
        selectedButton = btnSelectTeam1
        addTransparentView(frames: btnSelectTeam1.frame)
    }
    
    @IBAction func onClickSelectTeam2(_ sender: Any) {
        let Teams = store.getAllTeams()
        var teamNames = [String]()
        for team in Teams {
            teamNames.append(team.teamName)
        }
        
        dataSource = teamNames
        selectedButton = btnSelectTeam2
        addTransparentView(frames: btnSelectTeam2.frame)
    }
    
    @IBAction func onClickSelectPlayer(_ sender: Any) {
        if(btnSelectTeam1.currentTitle != nil) {
            var selectedTeam1 : Team
            selectedTeam1 = store.getTeamByTeamName(teamName: btnSelectTeam1.currentTitle!)
            team1 = selectedTeam1
        let Players = store.getAllPlayersOnTeam(selectedTeam1)
        var Names = [String]()
        for player in Players {
            Names.append(player.getFullName())
            team1_playersList.append(player)
        }
        dataSource = Names
        selectedButton = btnSelectPlayer1
        addTransparentView(frames: btnSelectPlayer1.frame)
    }
    }
    @IBAction func onClickSelectPlayer2(_ sender: Any) {
        if(btnSelectTeam2.currentTitle != nil) {
            var selectedTeam2 : Team
            selectedTeam2 = store.getTeamByTeamName(teamName: btnSelectTeam2.currentTitle!)
            team2 = selectedTeam2
        let Players = store.getAllPlayersOnTeam(selectedTeam2)
        var Names = [String]()
        for player in Players {
            Names.append(player.getFullName())
            team2_playersList.append(player)
        }
        dataSource = Names
        selectedButton = btnSelectPlayer2
        addTransparentView(frames: btnSelectPlayer2.frame)
    }
    }
    
    @IBAction func onClickAddTrade(_ sender: Any) {
        if (btnSelectTeam1.currentTitle != nil){
            if(btnSelectTeam2.currentTitle != nil){
                if(btnSelectPlayer1.currentTitle != nil){
                    if(btnSelectPlayer2.currentTitle != nil)
                    {
                        for player in team1_playersList {
                            if(player.getFullName() == btnSelectPlayer1.currentTitle) {
                                player1.append(player)
                            }
                        }
                        for player in team2_playersList {
                            if(player.getFullName() == btnSelectPlayer2.currentTitle) {
                                player2.append(player)
                            }
                        }
                                    
                        let tradeObj = Trade(team1, team2, player1, player2, date: Date.now)
                        store.createTrade(tradeObj: tradeObj)
                        self.navigationController?.popViewController(animated: true)
                        
                    }
                }
            }
        }
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
