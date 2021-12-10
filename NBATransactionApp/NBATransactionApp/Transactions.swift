//
//  Transactions.swift
//  NBATransactionApp
//
//  Created by csuftitan on 12/8/21.
//

import Foundation

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
}

class Player {
    var firstName : String!
    var lastName : String!
    var teamId : Int64?
    
    init(_ fName : String, _ lName : String) {
        firstName = fName
        lastName = lName
    }
    
    init?(_ fName : String, _ lName : String, _ tId : Int64) {
        firstName = fName
        lastName = lName
        teamId = tId
    }
}

class Trade : Transaction {
    var transactionId : Int64?
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
}




