//
//  HallOfFameService.swift
//  RxBullsEye
//
//  Created by jae hyeong ahn on 2020/01/28.
//  Copyright © 2020 usinuniverse. All rights reserved.
//

import RxSwift

enum HallOfFameEvent {
    case update
}

protocol HallOfFameServiceType {
    var serviceProvider: ServiceProviderType { get }
    var event: PublishSubject<HallOfFameEvent> { get }
    
    func create(record: Record) -> Observable<Record>
    func read() -> Observable<[Record]>
    func update(name: String) -> Observable<[Record]>
    func delete(at index: Int) -> Observable<Record>
}
