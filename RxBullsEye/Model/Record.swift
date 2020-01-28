//
//  Record.swift
//  RxBullsEye
//
//  Created by jae hyeong ahn on 2020/01/28.
//  Copyright © 2020 usinuniverse. All rights reserved.
//

import Foundation

import RxDataSources

struct Record: IdentifiableType, Equatable {
    var name: String
    var score: Int
    var identity: String
    
    init(name: String, score: Int) {
        self.name = name
        self.score = score
        self.identity = UUID().uuidString
    }
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.score = dictionary["score"] as? Int ?? 0
        self.identity = dictionary["identity"] as? String ?? UUID().uuidString
    }
    
    func convertToDict() -> [String: Any] {
        return ["name": self.name, "score": self.score, "identity": self.identity]
    }
    
}

struct SectionOfRecord {
    var items: [Item]
    var identity: String = "identity" // Only one section
}

extension SectionOfRecord: AnimatableSectionModelType {
    typealias Item = Record
    
    init(original: SectionOfRecord, items: [Item]) {
        self = original
        self.items = items
    }
}
