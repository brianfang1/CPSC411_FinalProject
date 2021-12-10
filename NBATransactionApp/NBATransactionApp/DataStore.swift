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
    
    // Define transactions table
    var transactionTbl : Table!
    var transactionId : Expression<Int64>!
    var transactionDate : Expression<Date>!
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

        // Create transactions table
        transactionTbl = Table("transaction")
        transactionDate = Expression<Date>("date")
        transactionId = Expression<Int64>("transaction_id")
        team1_id = Expression<Int64>("team1_id")
        team2_id = Expression<Int64>("team2_id")
        team1_playersToTrade = Expression<String>("team1_players_to_trade")
        team2_playersToTrade = Expression<String>("team2_players_to_trade")
        let crTransactionTbl = transactionTbl.create(ifNotExists: true) { t in
            t.column(transactionId, primaryKey: .autoincrement)
            t.column(transactionDate)
            t.column(team1_id)
            t.column(team2_id)
            t.column(team1_playersToTrade)
            t.column(team2_playersToTrade)
            t.foreignKey(team1_id, references: teamTbl, teamId, delete: .setNull)
            t.foreignKey(team2_id, references: teamTbl, teamId, delete: .setNull)
        }
        
        try! conn.run(crTeamTbl)
        try! conn.run(crPlayerTbl)
        try! conn.run(crTransactionTbl)
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
    
    // Create team
    func createTeam(teamObj : Team) {
        let conn = database.conn!
        let tbl = database.teamTbl!
        let insStmt = tbl.insert(database.teamNameCol <- teamObj.teamName)
        try! conn.run(insStmt)
        print("Team Added: \(String(describing: teamObj.teamName))")
    }
    
    func createPlayer(playerObj : Player) {
        let conn = database.conn!
        let tbl = database.playerTbl!
        let insStmt = tbl.insert(database.fnCol <- playerObj.firstName, database.lnCol <- playerObj.lastName, database.teamId <- playerObj.teamId!)
        try! conn.run(insStmt)
        print("Player Added: \(String(describing: playerObj.firstName)) \(String(describing: playerObj.lastName))")
    }
}
