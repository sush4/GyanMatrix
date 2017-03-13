//
//  Player.swift
//  GyanMatrix
//
//  Created by Sushant kumar on 12/03/17.
//  Copyright © 2017 Sushant kumar. All rights reserved.
//

import Foundation

class Player: NSObject {
    var id : Double
    var name : String
    var image : String
    var totalScore : Double
    var descriptions : String
    var matchesPlayed : Double
    var country : String
    var favorite : Bool
    
    override init() {
        id = 0
        name = ""
        image = ""
        totalScore = 0
        descriptions = ""
        matchesPlayed = 0
        country = ""
        favorite = false
    }
    
    init(id : Double, name : String, image : String, totalScore : Double, descriptions : String, matchesPlayed : Double, country : String) {
        self.id = id
        self.name = name
        self.image = image
        self.totalScore = totalScore
        self.descriptions = descriptions
        self.matchesPlayed = matchesPlayed
        self.country = country
        self.favorite = false
    }
    
}
