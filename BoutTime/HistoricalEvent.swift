//
//  HistoricalEvent.swift
//  BoutTime
//
//  Created by Khalid Alrashed on 7/30/17.
//  Copyright © 2017 Khalid Alrashed. All rights reserved.
//

import Foundation
import GameKit

protocol EventContent {
    var name: String { get }
    var date: Int { get }
    var url: String { get }
}

struct Event: EventContent {
    let name: String
    let date: Int
    let url: String
}

protocol HistoricalEvent {
    var roundsPlayed: Int { get set }
    var totalRounds: Int { get }
    var points: Int { get set }
    var secondsPerRound: Int { get }
    var collection: [Event] { get }
    
    init(collection: [Event])
    func pickRandomEvents() -> [Event]
    func checkOrderOfEvents(from array: [Event]) -> Bool
}

enum CollectionError: Error {
    case invalidResource
    case conversionFailure
    case invalidEvent
}

class PlistConverter {
    static func collectionArray(fromFile name: String, ofType type: String) throws -> [[String: AnyObject]] {
        guard let path = Bundle.main.path(forResource: name, ofType: type) else {
            throw CollectionError.invalidResource
        }
        
        guard let collectionArray = NSArray(contentsOfFile: path) as? [[String: AnyObject]] else {
            throw CollectionError.conversionFailure
        }
        
        return collectionArray
    }
}

class CollectionUnarchiver {
    static func gameCollection(fromArray array: [[String: AnyObject]]) throws -> [Event] {
        var collection: [Event] = []
        
        for dictionary in array {
            if let name = dictionary["event"] as? String, let date = dictionary["date"] as? Int, let url = dictionary["url"] as? String {
                let event = Event(name: name, date: date, url: url)
                
                collection.append(event)
            } else {
                throw CollectionError.invalidEvent
            }
        }
        
        return collection
    }
}

class HistoricalEventGame: HistoricalEvent {
    let secondsPerRound: Int = 60
    let totalRounds: Int = 6
    var roundsPlayed: Int = 0
    var points: Int = 0
    var collection: [Event]

    required init(collection: [Event]) {
        self.collection = collection
    }
    
    func pickRandomEvents() -> [Event] {
        var randomEvents: [Event] = []
        var uniqueIndices: [Int] = []
        
        while uniqueIndices.count < 4 {
            let randomIndex = GKRandomSource.sharedRandom().nextInt(upperBound: collection.count)
            if !uniqueIndices.contains(randomIndex) {
                uniqueIndices.append(randomIndex)
            }
        }
        
        for index in 0..<uniqueIndices.count {
            randomEvents.append(collection[uniqueIndices[index]])
        }
        
        return randomEvents
    }
    
    func checkOrderOfEvents(from array: [Event]) -> Bool {
        if array[0].date < array[1].date, array[1].date < array[2].date, array[2].date < array[3].date {
            return true
        } else {
            return false
        }
    }
}
