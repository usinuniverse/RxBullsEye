//
//  HallOfFameViewReactor.swift
//  RxBullsEye
//
//  Created by jae hyeong ahn on 2020/01/28.
//  Copyright © 2020 usinuniverse. All rights reserved.
//

import ReactorKit
import RxSwift

class HallOfFameViewReactor: Reactor {
    // MARK: - Enum
    
    enum Action {
        case refresh
        case delete(Int)
    }
    
    enum Mutation {
        case setRecords([SectionOfRecord])
        case deleteRecord(Int)
    }
    
    struct State {
        let title = "Hall Of Fame 🏆"
        var records = [SectionOfRecord]()
    }
    
    // MARK: - Properties
    
    var initialState = State()
    
    var serviceProvider: ServiceProviderType
    
    // MARK: Initialization
    
    init(serviceProvider: ServiceProviderType) {
        self.serviceProvider = serviceProvider
    }
    
    // MARK: - Methods
    
    func mutate(action: HallOfFameViewReactor.Action) -> Observable<HallOfFameViewReactor.Mutation> {
        switch action {
        case .refresh:
            return self.serviceProvider.hallOfFameService.read()
                .flatMap { records -> Observable<Mutation> in
                    let sectionOfRecord = SectionOfRecord(items: records)
                    return Observable.just(.setRecords([sectionOfRecord]))
            }
            
        case .delete(let index):
            return self.serviceProvider.hallOfFameService.delete(at: index)
                .flatMap { _ -> Observable<Mutation> in
                    return Observable.just(.deleteRecord(index))
            }
        }
    }
    
    func reduce(state: HallOfFameViewReactor.State, mutation: HallOfFameViewReactor.Mutation) -> HallOfFameViewReactor.State {
        var state = state
        
        switch mutation {
        case .setRecords(let sectionOfRecord):
            state.records = sectionOfRecord
            
        case .deleteRecord(let index):
            state.records[0].items.remove(at: index)
        }
        
        return state
    }
    
    func createRegisterViewReactor() -> RegisterViewReactor {
        return RegisterViewReactor(serviceProvider: self.serviceProvider)
    }
    
}

