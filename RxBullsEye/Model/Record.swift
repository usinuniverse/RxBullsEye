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
}

struct SectionOfRecord {
    var items: [Item]
}

extension SectionOfRecord: AnimatableSectionModelType {
    typealias Item = Record
    
    var identity: String {
        return UUID().uuidString
    }
    
    init(original: SectionOfRecord, items: [Item]) {
        self = original
        self.items = items
    }
}
