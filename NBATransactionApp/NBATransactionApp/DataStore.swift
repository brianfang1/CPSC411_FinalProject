//
//  DataStore.swift
//  NBATransactionApp
//
//  Created by csuftitan on 12/8/21.
//

import Foundation
import SQLite

class Database {
    var conn : Connection!
    
    // Define team table
    var teamTbl : Table!
    var teamId : Expression<Int64>!
    var teamNameCol : Expression<String>!
    
    // Define player table
    var playerTbl : Table!
    var playerId : Expression<Int64>!
    var fnCol : Expression<String>!
    var lnCol : Expression<String>!
    // teamId foreign key from teamTbl or NULL
    
    // Define trades table
    var tradeTbl : Table!
    var tradeId : Expression<Int64>!
    var tradeDate : Expression<Date>!
    var team1_id : Expression<Int64>!
    var team2_id : Expression<Int64>!
    var team1_playersToTrade : Expression<String>!
    var team2_playersToTrade : Expression<String>!
    
    
    init() {
        let rootPath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let dbPath = rootPath.appendingPathComponent("NBATransactions.sqlite").path
        print("Sqlite database location: \(dbPath)")
        
        // Create or Open the Database Connection
        conn = try! Connection(dbPath)
        
        //
        initialize()
    }
    
    func getLocation() -> Void {
        let rootPath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let dbPath = rootPath.appendingPathComponent("Campus.sqlite").path
        print("Sqlite database location: \(dbPath)")
    }
    
    func initialize() {
        // Create team table
        teamTbl = Table("team")
        teamNameCol = Expression<String>("team_name")
        teamId = Expression<Int64>("team_id")
        let crTeamTbl = teamTbl.create(ifNotExists: true) {
            t in
            t.column(teamId, primaryKey: .autoincrement)
            t.column(teamNameCol, unique: true)
        }
        
        // Create player table
        playerTbl = Table("player")
        fnCol = Expression<String>("first_name")
        lnCol = Expression<String>("last_name")
        playerId = Expression<Int64>("player_id")
        let crPlayerTbl = playerTbl.create(ifNotExists: true) { t in
            t.column(playerId, primaryKey: .autoincrement)
            t.column(fnCol)
            t.column(lnCol)
            t.column(teamId)
            t.foreignKey(teamId, references: teamTbl, teamId, delete: .setNull)
        }

        // Create trades table
        tradeTbl = Table("trade")
        tradeDate = Expression<Date>("date")
        tradeId = Expression<Int64>("trade_id")
        team1_id = Expression<Int64>("team1_id")
        team2_id = Expression<Int64>("team2_id")
        team1_playersToTrade = Expression<String>("team1_players_to_trade")
        team2_playersToTrade = Expression<String>("team2_players_to_trade")
        let crTradeTbl = tradeTbl.create(ifNotExists: true) { t in
            t.column(tradeId, primaryKey: .autoincrement)
            t.column(tradeDate)
            t.column(team1_id)
            t.column(team2_id)
            t.column(team1_playersToTrade)
            t.column(team2_playersToTrade)
            t.foreignKey(team1_id, references: teamTbl, teamId, delete: .setNull)
            t.foreignKey(team2_id, references: teamTbl, teamId, delete: .setNull)
        }
        
        try! conn.run(crTeamTbl)
        try! conn.run(crPlayerTbl)
        try! conn.run(crTradeTbl)
    }
}

// Singleton Object
class DataStore {
    static private var instance : DataStore!
    var database = Database()
    
    static func get() -> DataStore {
        if instance == nil {
            instance = DataStore()
        }
        return instance
    }
    
    // NOT tested
    // Get all teams
    func getAllTeams() -> [Team]{
        var teamList = [Team]()
        let conn = database.conn!
        let tbl = database.teamTbl!
        let rs = try! conn.prepare(tbl)
        for r in rs {
            let teamObj = try! Team(r.get(database.teamNameCol))
            teamList.append(teamObj)
        }
        return teamList
    }
    
    // NOT tested
    // Get all players
    func getAllPlayers() -> [Player]{
        var playersList = [Player]()
        let conn = database.conn!
        let firstName = Expression<String>("first_name")
        let lastName = Expression<String>("last_name")
        let tbl = database.playerTbl!.order(firstName.desc, lastName)
        let rs = try! conn.prepare(tbl)
        for r in rs {
            let playerObj = try! Player(r.get(database.fnCol), r.get(database.lnCol), r.get(database.teamId))
            playersList.append(playerObj!)
        }
        return playersList
    }
    
    // NOT tested
    func getAllTrades() -> [Trade] {
        var tradesList = [Trade]()
        let conn = database.conn!
        let tradeDate = Expression<Date>("date")
        let tbl = database.tradeTbl!.order(tradeDate.desc)
        let rs = try! conn.prepare(tbl)
        for r in rs {
            let tradeObj = try! Trade(r.get(database.tradeId), Team(id: r.get(database.team1_id))!, Team(id: r.get(database.team2_id))!, players_StringToArray(r.get(database.team1_playersToTrade)), players_StringToArray(r.get(database.team2_playersToTrade)), r.get(database.tradeDate))
            tradesList.append(tradeObj!)
        }
        return tradesList
    }
    
    // NOT tested
    func getPlayerById(_ id : Int64) -> Player {
        // ASSUME ID EXISTS IN DB. NO ERROR HANDLING
        var playerObj : Player!
        let tbl = database.playerTbl!
        let conn = database.conn!
        let filterTbl = tbl.filter(database.playerId == id)
        let rs = try! conn.prepare(filterTbl)
        for r in rs {
            // There should only be one as teamId is unique
            playerObj = try! Player(r.get(database.fnCol), r.get(database.lnCol), r.get(database.teamId))
        }
        return playerObj
    }
    
    // NOT tested
    func getTeamById(_ id : Int64) -> Team {
        // ASSUME ID EXISTS IN DB
        var teamObj : Team!
        let tbl = database.teamTbl!
        let conn = database.conn!
        let filterTbl = tbl.filter(database.teamId == id)
        let rs = try! conn.prepare(filterTbl)
        for r in rs {
            // There should only be one as teamId is unique
                teamObj = try! Team(r.get(database.teamNameCol), r.get(database.teamId))
        }
        return teamObj
    }
    
    // TESTED: WORKS
    // Create team. Assume Team does not exist in Database or else error is thrown
    func createTeam(teamObj : Team) {
        let conn = database.conn!
        let tbl = database.teamTbl!
        let insStmt = tbl.insert(database.teamNameCol <- teamObj.teamName)
        try! conn.run(insStmt)
        print("Team Added: \(String(describing: teamObj.teamName))")
    }
    
    // TESTED: WORKS
    func createPlayer(playerObj : Player) {
        let conn = database.conn!
        let tbl = database.playerTbl!
        let insStmt = tbl.insert(
            database.fnCol <- playerObj.firstName,
            database.lnCol <- playerObj.lastName,
            database.teamId <- playerObj.teamId!
        )
        try! conn.run(insStmt)
        print("Player Added: \(String(describing: playerObj.firstName)) \(String(describing: playerObj.lastName))")
    }
    
    
    // DOES NOT ERROR CHECK ANYTHING. EVERYTHING SHOULD BE CHECKED ON THE FRONT END
    // TESTED: WORKS
    func createTrade(tradeObj : Trade) {
        let conn = database.conn!
        
        // Insert transaction into trade table
        let tradeTable = database.tradeTbl!
        let insStmt = tradeTable.insert(
            database.tradeDate <- tradeObj.transactionDate,
            database.team1_id <- tradeObj.team1.teamId!,
            database.team2_id <- tradeObj.team2.teamId!,
            database.team1_playersToTrade <- players_ArrayToString(tradeObj.team1_players),
            database.team2_playersToTrade <- players_ArrayToString(tradeObj.team2_players)
        )
        try! conn.run(insStmt)
        
        // Trade the players
        // Change traded players' teamId
        let playerTable = database.playerTbl!
        let playerId = Expression<Int64>("player_id")
        let teamId = Expression<Int64>("team_id")
        for player in tradeObj.team1_players {
            let playerById = playerTable.filter(playerId == player.playerId!)
            let updateStmt = playerById.update(teamId <- tradeObj.team2.teamId!)
            try! conn.run(updateStmt)
        }
        for player in tradeObj.team2_players {
            let playerById = playerTable.filter(playerId == player.playerId!)
            let updateStmt = playerById.update(teamId <- tradeObj.team1.teamId!)
            try! conn.run(updateStmt)
        }
    }
}
