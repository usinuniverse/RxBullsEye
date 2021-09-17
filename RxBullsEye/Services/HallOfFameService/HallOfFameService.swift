//
//  HallOfFameService.swift
//  RxBullsEye
//
//  Created by jae hyeong ahn on 2020/01/28.
//  Copyright © 2020 usinuniverse. All rights reserved.
//

import RxSwift

class HallOfFameService: HallOfFameServiceType {
    // MARK: - Properties
    
    var serviceProvider: ServiceProviderType
    
    var event = PublishSubject<HallOfFameEvent>()
    
    // MARK: - Initialization
    
    init(serviceProvider: ServiceProviderType) {
        self.serviceProvider = serviceProvider
    }
    
    func create(record: Record) -> Observable<Record> {
        return read()
            .withUnretained(self)
            .flatMap { weakSelf, records -> Observable<Record> in
                var records = records
                records.append(record)
                records.sort { $0.score > $1.score }
                weakSelf.serviceProvider.userDefaultsService.set(value: records.map({ $0.convertToDict() }), forKey: UserDefaultsService.Key.hallOfFame.rawValue)
                return .just(record)
        }
    }
    
    func read() -> Observable<[Record]> {
        if let savedRecords = serviceProvider.userDefaultsService.value(forKey: UserDefaultsService.Key.hallOfFame.rawValue) as? [[String: Any]] {
            let records = savedRecords.map { Record(dictionary: $0) }
            return .just(records)
        } else {
            return .just([])
        }
    }
    
    func update(name: String) -> Observable<[Record]> {
        return read()
            .withUnretained(self)
            .do(onNext: { weakSelf, _ in
                weakSelf.event.onNext(.update)
            })
            .flatMap { weakSelf, records -> Observable<[Record]> in
                var newRecords = [Record]()
                records.forEach {
                    newRecords.append(Record(name: name, score: $0.score))
                }
                weakSelf.serviceProvider.userDefaultsService.set(value: newRecords.map { $0.convertToDict() }, forKey: UserDefaultsService.Key.hallOfFame.rawValue)
                weakSelf.serviceProvider.userDefaultsService.set(value: name, forKey: UserDefaultsService.Key.name.rawValue)
                return .just(newRecords)
            }
    }
    
    func delete(at index: Int) -> Observable<Record> {
        return read()
            .withUnretained(self)
            .flatMap { weakSelf, records -> Observable<Record> in
                var records = records
                let removedRecord = records.remove(at: index)
                weakSelf.serviceProvider.userDefaultsService.set(value: records.map { $0.convertToDict() }, forKey: UserDefaultsService.Key.hallOfFame.rawValue)
                return .just(removedRecord)
        }
    }
}

