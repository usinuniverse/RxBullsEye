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
        return self.read()
            .flatMap { [weak self] records -> Observable<Record> in
                var records = records
                records.append(record)
                records.sort { $0.score > $1.score }
                self?.serviceProvider.userDefaultsService.set(value: records.map({ $0.convertToDict() }), forKey: UserDefaultsService.Key.hallOfFame.rawValue)
                return Observable.just(record)
        }
    }
    
    func read() -> Observable<[Record]> {
        if let savedRecords = self.serviceProvider.userDefaultsService.value(forKey: UserDefaultsService.Key.hallOfFame.rawValue) as? [[String: Any]] {
            let records = savedRecords.map { Record(dictionary: $0) }
            return Observable.just(records)
        } else {
            return Observable.just([])
        }
    }
    
    func update(name: String) -> Observable<[Record]> {
        return self.read()
            .flatMap { [weak self] records -> Observable<[Record]> in
                var newRecords = [Record]()
                records.forEach {
                    newRecords.append(Record(name: name, score: $0.score))
                }
                self?.serviceProvider.userDefaultsService.set(value: newRecords, forKey: UserDefaultsService.Key.hallOfFame.rawValue)
                self?.serviceProvider.userDefaultsService.set(value: name, forKey: UserDefaultsService.Key.name.rawValue)
                return Observable.just(newRecords)
        }
        .do(onNext: { [weak self] _ in
            self?.event.onNext(.update)
        })
    }
    
    func delete(at index: Int) -> Observable<Record> {
        return self.read()
            .flatMap { [weak self] records -> Observable<Record> in
                var records = records
                let removedRecord = records.remove(at: index)
                self?.serviceProvider.userDefaultsService.set(value: records.map { $0.convertToDict() }, forKey: UserDefaultsService.Key.hallOfFame.rawValue)
                return Observable.just(removedRecord)
        }
    }
    
}

