//
//  Transactions.swift
//  NBATransactionApp
//
//  Created by csuftitan on 12/8/21.
//

import Foundation


let store = DataStore.get()

class Transaction {
    var transactionDate : Date!
    
    init(_ date : Date) {
        transactionDate = date
    }
}

class Team {
    var teamName : String!
    var teamId : Int64?
    
    init(_ name : String) {
        teamName = name
    }
    
    init?(_ name : String, _ id : Int64) {
        teamName = name
        teamId = id
    }
    init?(id : Int64) {
        // No error handling. Assume ID EXISTS or else error WILL occur
        let teamObj = store.getTeamById(id)
        teamName = teamObj.teamName
        teamId = teamObj.teamId
    }
}

class Player {
    var firstName : String!
    var lastName : String!
    var teamId : Int64?
    var playerId : Int64?
    
    
    init(_ fName : String, _ lName : String) {
        firstName = fName
        lastName = lName
    }
    
    init?(_ fName : String, _ lName : String, _ tId : Int64) {
        firstName = fName
        lastName = lName
        teamId = tId
    }
    
    init?(id : Int64) {
        // No error handling. Assume ID EXISTS or else error WILL occur
        let playerObj = store.getPlayerById(id)
        playerId = id
        firstName = playerObj.firstName
        lastName = playerObj.lastName
        teamId = playerObj.teamId
    }
    
    init?(_ id : Int64, _ fName : String, _ lName : String, _ tId : Int64) {
        playerId = id
        firstName = fName
        lastName = lName
        teamId = tId
        
    }
    
    
    func getFullName() -> String {
        return firstName + " " + lastName
    }
}

class Trade : Transaction {
    // Team1_players and Team2_players will be stored as an array of Player objects BUT in the database, they will be a String of playerId delimited by ",". Need to convert when storing and retrieving***
    var tradeId : Int64?
    var team1 : Team!
    var team1_players : [Player]!
    var team2 : Team!
    var team2_players : [Player]!
    
    init( _ t1 : Team, _ t2 : Team, _ t1_players : [Player], _ t2_players : [Player], date : Date) {
        super.init(date)
        team1 = t1
        team2 = t2
        team1_players = t1_players
        team2_players = t2_players
    }
    
    init?( _ trade_id : Int64, _ t1 : Team, _ t2 : Team, _ t1_players : [Player], _ t2_players : [Player], _ date : Date) {
        super.init(date)
        tradeId = trade_id
        team1 = t1
        team2 = t2
        team1_players = t1_players
        team2_players = t2_players
    }
}

// TESTED: WORKS
func players_ArrayToString(_ players : [Player]) -> String {
    // playersString contains playerId of players ex. "1, 2, ..."
    var playerIdArray = [String]()
    var playerIdString : String
    for player in players {
        playerIdArray.append(String(player.playerId!))
    }
    
    playerIdString = playerIdArray.joined(separator: ", ")
    
    return playerIdString
}

func players_StringToArray(_ playerIdString : String ) -> [Player] {
    // Given a String of playerId, create a an array of Player objects. playerIdString = "1, 2, 3, ..."
    var playerIdArray : [String]
    var players = [Player]()
    playerIdArray = playerIdString.components(separatedBy: ", ")
    for id in playerIdArray {
        let playerObj = Player(id: Int64(id)!)!
        players.append(playerObj)
    }
    return players
}




