//
//  score.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/8/18.
//
import Foundation

class Score : NSObject, NSCoding, Comparable {
    
    var playerName : String
    var score : Int
    var seasons : Int
    
    init (name: String, score: Int, seasons: Int) {
        playerName = name
        self.score = score
        self.seasons = seasons
    }
    
    required convenience init?(coder: NSCoder)
    {
        guard let decodedName = coder.decodeObject(forKey: "name") as? String
        else { return nil }

        self.init(
            name: decodedName,
            score: coder.decodeInteger(forKey: "score"),
            seasons: coder.decodeInteger(forKey: "seasons")
        )
    }
    
   
    func encode(with coder: NSCoder) {
        coder.encode(score, forKey: "score")
        coder.encode(playerName, forKey: "name")
        coder.encode(seasons, forKey: "seasons")
    }
    
    static func < (left : Score, right : Score) -> Bool {
        if left.score == right.score && left.seasons == right.seasons {
            return true
        } else if left.score == right.score {
            return left.seasons > right.seasons
        } else {
            return left.score > right.score
        }
    }
    
    static func == (lhs: Score, rhs: Score) -> Bool {
        return lhs.score == rhs.score && lhs.seasons == rhs.seasons
    }
    
}
