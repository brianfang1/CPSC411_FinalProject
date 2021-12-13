//
//  InsertData.swift
//  NBATransactionApp
//  Functions to insert initial data
//
//  Created by csuftitan on 12/9/21.
//

import Foundation


// Only run once to store data into database
func insertTeams(store : DataStore) {
    let Lakers = Team("Lakers")
    let Clippers = Team("Clippers")
    store.createTeam(teamObj: Lakers)
    store.createTeam(teamObj: Clippers)
}

// // Only run once to store data into database
func insertPlayers(store : DataStore) {
    let lakersList = [
        Player("Carmelo", "Anthony", 1),
        Player("Trevor", "Ariza", 1),
        Player("Kent", "Bazemore", 1),
        Player("Avery", "Bradley", 1),
        Player("Anthony", "Davis", 1),
        Player("Wayne", "Ellington", 1),
        Player("Talen", "Horton-Tucker", 1),
        Player("Dwight", "Howard", 1),
        Player("Lebron", "James", 1),
        Player("Deandre", "Jordan", 1),
        Player("Malik", "Monk", 1),
        Player("Kendrick", "Nunn", 1),
        Player("Austin", "Reaves", 1),
        Player("Rajon", "Rondo", 1),
        Player("Russel", "Westbrook", 1),
        Player("Chaundee", "Brown", 1),
        Player("Jay", "Huff", 1)
    ]
    let clippersList = [
        Player("Nicolas", "Batum", 2),
        Player("Eric", "Bledsoe", 2),
        Player("Brandon", "Boston Jr.", 2),
        Player("Amir", "Coffey", 2),
        Player("Paul", "George", 2),
        Player("Isaiah", "Hartenstein", 2),
        Player("Serge", "Ibaka", 2),
        Player("Reggie", "Jackson", 2),
        Player("Keon", "Johnson", 2),
        Player("Luke", "Kennard", 2),
        Player("Kawhi", "Leonard", 2),
        Player("Terrance", "Mann", 2),
        Player("Marcus", "Morris Sr.", 2),
        Player("Jason", "Preston", 2),
        Player("Jay", "Scrubb", 2),
        Player("Justice", "Winslow", 2),
        Player("Ivica", "Zubac", 2)
    ]
    for player in lakersList {
        store.createPlayer(playerObj: player!)
    }
    for player in clippersList {
        store.createPlayer(playerObj: player!)
    }
}

// Only run once to store transactions into database
func insertTransactions(store : DataStore) {
    let tradeObj =  Trade(Team("Lakers", 1)!, Team("Clippers", 2)!, [Player(1, "Carmelo", "Anthony", 1)!, Player(2, "Trevor", "Ariza", 1)!], [Player(34, "Ivica", "Zubac", 2)!], date: Date.now)
    
    let tradeObj2 =  Trade(Team("Clippers", 2)!, Team("Lakers", 1)!, [Player(1, "Carmelo", "Anthony", 1)!, Player(2, "Trevor", "Ariza", 1)!], [Player(34, "Ivica", "Zubac", 2)!], date: Date.now)
    
    store.createTrade(tradeObj: tradeObj)
    store.createTrade(tradeObj: tradeObj2)
}
